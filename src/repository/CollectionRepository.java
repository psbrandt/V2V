package repository;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TypedQuery;

import model.Collection;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

@Repository
@Transactional
public class CollectionRepository {
  @PersistenceContext
  private EntityManager em;

  public void saveCollection(Collection collection) {
    em.persist(collection);
    em.flush();
  }

  public Collection updateCollection(Collection collection, Long collectionId) {
    Collection existingCollection = findCollectionById(collectionId);
    existingCollection.copy(collection);
    em.merge(existingCollection);
    em.flush();
    return existingCollection;
  }

  public Collection findCollectionById(Long collectionId) {
    return em.find(Collection.class, collectionId);
  }

  public void deleteAllCollections() {
    Query query = em.createQuery("DELETE FROM Collection c");
    query.executeUpdate();
  }

  public Collection findCollectionByNumber(String collectionNumber) {
    TypedQuery<Collection> query = em
        .createQuery(
            "SELECT c FROM Collection c WHERE c.collectionNumber = :collectionNumber and c.isDeleted= :isDeleted",
            Collection.class);
    query.setParameter("isDeleted", Boolean.FALSE);
    query.setParameter("collectionNumber", collectionNumber);
    List<Collection> collections = query.getResultList();
    if (CollectionUtils.isEmpty(collections)) {
      return null;
    }
    return collections.get(0);
  }

  public List<Collection> getAllCollections() {
    Query query = em.createQuery(
        "SELECT c FROM Collection c WHERE c.isDeleted= :isDeleted",
        Collection.class);
    query.setParameter("isDeleted", Boolean.FALSE);
    return query.getResultList();
  }

  public List<Collection> getCollections(Date fromDate, Date toDate) {
    TypedQuery<Collection> query = em
        .createQuery(
            "SELECT c FROM Collection c WHERE c.dateCollected >= :fromDate and c.dateCollected<= :toDate and c.isDeleted= :isDeleted",
            Collection.class);
    query.setParameter("isDeleted", Boolean.FALSE);
    query.setParameter("fromDate", fromDate);
    query.setParameter("toDate", toDate);
    List<Collection> collections = query.getResultList();
    if (CollectionUtils.isEmpty(collections)) {
      return new ArrayList<Collection>();
    }
    return collections;
  }

  public void deleteCollection(Long collectionId) {
    Collection existingCollection = findCollectionById(collectionId);
    existingCollection.setIsDeleted(Boolean.TRUE);
    em.merge(existingCollection);
    em.flush();
  }

  public List<Collection> findAnyCollectionMatching(String collectionNumber,
      String sampleNumber, String shippingNumber, String dateCollectedFrom,
      String dateCollectedTo, List<String> centers) {

    // TODO: fix join condition
    TypedQuery<Collection> query = em.createQuery(
        "SELECT c FROM Collection c, Location L WHERE "
            + " L.locationId=c.centerId AND L.isCenter=TRUE AND ("
            + "c.collectionNumber = :collectionNumber OR "
            + "c.sampleNumber = :sampleNumber OR "
            + "c.shippingNumber = :shippingNumber OR "
            + "L.name IN (:centers)) AND ("
            + "c.dateCollected BETWEEN :dateCollectedFrom AND "
            + ":dateCollectedTo" + ") AND " + "(c.isDeleted= :isDeleted)",
        Collection.class);

    query.setParameter("isDeleted", Boolean.FALSE);
    String collectionNo = ((collectionNumber == null) ? "" : collectionNumber);
    query.setParameter("collectionNumber", collectionNo);
    Long sampleNo = ((sampleNumber == null) ? -1 : Long.parseLong(sampleNumber));
    query.setParameter("sampleNumber", sampleNo);
    Long shippingNo = ((shippingNumber == null) ? -1 : Long
        .parseLong(shippingNumber));
    query.setParameter("shippingNumber", shippingNo);

    query.setParameter("centers", centers);

    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
    try {
      Date from = (dateCollectedFrom == null || dateCollectedFrom.equals("")) ? dateFormat
          .parse("12/31/1970") : dateFormat.parse(dateCollectedFrom);
      query.setParameter("dateCollectedFrom", from);
    } catch (ParseException e) {
      e.printStackTrace();
    }
    try {
      Date to = (dateCollectedTo == null || dateCollectedTo.equals("")) ? dateFormat
          .parse(dateFormat.format(new Date())) : dateFormat
          .parse(dateCollectedTo);
      query.setParameter("dateCollectedTo", to);
    } catch (ParseException e) {
      e.printStackTrace();
    }

    List<Collection> resultList = query.getResultList();
    return resultList;
  }

  public Collection updateOrAddCollection(Collection collection) {
    Collection existingCollection = findCollectionByNumber(collection
        .getCollectionNumber());
    if (existingCollection == null) {
      collection.setIsDeleted(false);
      saveCollection(collection);
      return collection;
    }
    existingCollection.copy(collection);
    existingCollection.setIsDeleted(false);
    em.merge(existingCollection);
    em.flush();
    return existingCollection;
  }

  public Map<String, Long> findNumberOfCollections(String dateCollectedFrom,
      String dateCollectedTo) {

    TypedQuery<Object[]> query = em.createQuery(
        "SELECT count(c), c.dateCollected FROM Collection c WHERE "
            + "c.dateCollected BETWEEN :dateCollectedFrom AND "
            + ":dateCollectedTo AND (c.isDeleted= :isDeleted)"
            + "GROUP BY dateCollected", Object[].class);

    query.setParameter("isDeleted", Boolean.FALSE);

    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
    try {
      Date from = (dateCollectedFrom == null || dateCollectedFrom.equals("")) ? dateFormat
          .parse("12/31/1970") : dateFormat.parse(dateCollectedFrom);
      query.setParameter("dateCollectedFrom", from);
    } catch (ParseException e) {
      e.printStackTrace();
    }
    try {
      Date to = (dateCollectedTo == null || dateCollectedTo.equals("")) ? dateFormat
          .parse(dateFormat.format(new Date())) : dateFormat
          .parse(dateCollectedTo);
      query.setParameter("dateCollectedTo", to);
    } catch (ParseException e) {
      e.printStackTrace();
    }

    Map<String, Long> m = new HashMap<String, Long>();
    List<Object[]> resultList = query.getResultList();
    for (Object[] result : resultList) {
      Date d = (Date) result[1];
      m.put(dateFormat.format(d), (Long) result[0]);
    }
    return m;
  }
}
