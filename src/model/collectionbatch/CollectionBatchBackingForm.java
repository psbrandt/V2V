package model.collectionbatch;

import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;

import model.location.Location;

public class CollectionBatchBackingForm {

  @Valid
  private CollectionBatch collectionBatch;

  public CollectionBatchBackingForm() {
    collectionBatch = new CollectionBatch();
  }

  public CollectionBatch getCollectionBatch() {
    return collectionBatch;
  }

  public void setCollectionBatch(CollectionBatch collectionBatch) {
    this.collectionBatch = collectionBatch;
  }

  public Integer getId() {
    return collectionBatch.getId();
  }

  public void setId(Integer id) {
    collectionBatch.setId(id);
  }

  public String getBatchNumber() {
    return collectionBatch.getBatchNumber();
  }

  public void setBatchNumber(String batchNumber) {
    collectionBatch.setBatchNumber(batchNumber);
  }

  public String getCollectionCenter() {
    Location center = collectionBatch.getCollectionCenter();
    if (center == null || center.getId() == null)
      return null;
    return center.getId().toString();
  }

  public String getCollectionSite() {
    Location site = collectionBatch.getCollectionSite();
    if (site == null || site.getId() == null)
      return null;
    return site.getId().toString();
  }

  public void setCollectionCenter(String center) {
    if (StringUtils.isBlank(center)) {
      collectionBatch.setCollectionCenter(null);
    }
    else {
      Location l = new Location();
      try {
        l.setId(Long.parseLong(center));
        collectionBatch.setCollectionCenter(l);
      } catch (NumberFormatException ex) {
        ex.printStackTrace();
        collectionBatch.setCollectionCenter(null);
      }
    }
  }

  public void setCollectionSite(String collectionSite) {
    if (StringUtils.isBlank(collectionSite)) {
      collectionBatch.setCollectionSite(null);
    }
    else {
      Location l = new Location();
      try {
        l.setId(Long.parseLong(collectionSite));
        collectionBatch.setCollectionSite(l);
      } catch (NumberFormatException ex) {
        ex.printStackTrace();
        collectionBatch.setCollectionSite(null);
      }
    }
  }

  public String getNotes() {
    return collectionBatch.getNotes();
  }

  public void setNotes(String notes) {
    collectionBatch.setNotes(notes);
  }
}
