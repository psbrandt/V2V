package model.donor;

import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.OneToMany;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.Valid;

import model.address.ContactInformation;
import model.collectedsample.CollectedSample;
import model.modificationtracker.ModificationTracker;
import model.modificationtracker.RowModificationTracker;
import model.user.User;
import model.util.BloodAbo;
import model.util.BloodRhd;
import model.util.Gender;

import org.apache.commons.lang3.text.WordUtils;
import org.hibernate.annotations.Index;
import org.hibernate.validator.constraints.Length;

@Entity
public class Donor implements ModificationTracker {

  @Id
	@GeneratedValue(strategy = GenerationType.AUTO)
  @Column(nullable=false, updatable=false, insertable=false)
	private Long id;

  @Column(length=15)
  @Index(name="donor_donorNumber_index")
  @Length(max=15)
  private String donorNumber;

  @Column(length=20)
  @Index(name="donor_firstName_index")
  @Length(max=20)
	private String firstName;

  @Length(max=20)
  @Column(length=20)
  private String middleName;

  @Length(max=20)
  @Index(name="donor_lastName_index")
  @Column(length=20)
	private String lastName;

  @Length(max=20)
  @Column(length=20)
  private String callingName;

  @Enumerated(EnumType.STRING)
  @Column(length=15)
	private Gender gender;

  @Enumerated(EnumType.STRING)
  @Column(length=10)
  @Index(name="donor_bloodAbo_index")
  private BloodAbo bloodAbo;

  @Enumerated(EnumType.STRING)
  @Column(length=10)
  @Index(name="donor_bloodRhd_index")
  private BloodRhd bloodRhd;

  @Temporal(TemporalType.DATE)
	private Date birthDate;

  @Column(columnDefinition="TINYINT")
  private Integer age;

  @Column(length=15)
  private String nationalID;

  private Boolean ageSpecified;

  @Embedded
  @Valid
  private ContactInformation contactInformation;

  @Lob
	private String notes;

  @Valid
  private RowModificationTracker modificationTracker;

	private Boolean isDeleted;

  @OneToMany(mappedBy="donor")
  private List<CollectedSample> collectedSamples;
  
	public Donor() {
	  contactInformation = new ContactInformation();
	  modificationTracker = new RowModificationTracker();
	}

  public Long getId() {
    return id;
  }

  public String getDonorNumber() {
    return donorNumber;
  }

  public String getFirstName() {
    return firstName;
  }

  public String getMiddleName() {
    return middleName;
  }

  public String getLastName() {
    return lastName;
  }

  public Gender getGender() {
    return gender;
  }

  public BloodAbo getBloodAbo() {
    return bloodAbo;
  }

  public BloodRhd getBloodRhd() {
    return bloodRhd;
  }

  public Date getBirthDate() {
    return birthDate;
  }

  public String getNotes() {
    return notes;
  }

  public Boolean getIsDeleted() {
    return isDeleted;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public void setDonorNumber(String donorNumber) {
    this.donorNumber = donorNumber;
  }

  public void setFirstName(String firstName) {
    if (firstName != null)
      firstName = WordUtils.capitalize(firstName);
    this.firstName = firstName;
  }

  public void setMiddleName(String middleName) {
    if (middleName != null)
      middleName = WordUtils.capitalize(middleName);
    this.middleName = middleName;
  }

  public void setLastName(String lastName) {
    if (lastName != null)
      lastName = WordUtils.capitalize(lastName);
    this.lastName = lastName;
  }

  public void setGender(Gender gender) {
    this.gender = gender;
  }

  public void setBloodAbo(BloodAbo bloodAbo) {
    this.bloodAbo = bloodAbo;
  }

  public void setBloodRhd(BloodRhd bloodRhd) {
    this.bloodRhd = bloodRhd;
  }

  public void setBirthDate(Date birthDate) {
    this.birthDate = birthDate;
  }

  public void setNotes(String notes) {
    this.notes = notes;
  }

  public void setIsDeleted(Boolean isDeleted) {
    this.isDeleted = isDeleted;
  }

  public void copy(Donor donor) {
    assert (donor.getId().equals(this.getId()));
    setDonorNumber(donor.getDonorNumber());
    setFirstName(donor.getFirstName());
    setMiddleName(donor.getMiddleName());
    setLastName(donor.getLastName());
    contactInformation.copy(donor.getContactInformation());
    setBirthDate(donor.getBirthDate());
    setBloodAbo(donor.getBloodAbo());
    setBloodRhd(donor.getBloodRhd());
    setNotes(donor.getNotes());
    setGender(donor.getGender());
  }

  public List<CollectedSample> getCollectedSamples() {
    return collectedSamples;
  }

  public void setCollectedSamples(List<CollectedSample> collectedSamples) {
    this.collectedSamples = collectedSamples;
  }

  public ContactInformation getContactInformation() {
    return contactInformation;
  }

  public void setContactInformation(ContactInformation contactInformation) {
    this.contactInformation = contactInformation;
  }

  public String getAddress() {
    return contactInformation.getAddress();
  }

  public String getProvince() {
    return contactInformation.getProvince();
  }

  public String getDistrict() {
    return contactInformation.getDistrict();
  }

  public String getCity() {
    return contactInformation.getCity();
  }

  public String getState() {
    return contactInformation.getState();
  }

  public String getCountry() {
    return contactInformation.getCountry();
  }

  public String getZipcode() {
    return contactInformation.getZipcode();
  }

  public void setAddress(String address) {
    contactInformation.setAddress(address);
  }

  public void setCity(String city) {
    contactInformation.setCity(city);
  }

  public void setProvince(String province) {
    contactInformation.setProvince(province);
  }

  public void setDistrict(String district) {
    contactInformation.setDistrict(district);
  }

  public void setState(String state) {
    contactInformation.setState(state);
  }

  public void setCountry(String country) {
    contactInformation.setCountry(country);
  }

  public void setZipcode(String zipcode) {
    contactInformation.setZipcode(zipcode);
  }

  public String getPhoneNumber() {
    return contactInformation.getPhoneNumber();
  }

  public void setPhoneNumber(String phoneNumber) {
    contactInformation.setPhoneNumber(phoneNumber);
  }

  public Date getLastUpdated() {
    return modificationTracker.getLastUpdated();
  }

  public Date getCreatedDate() {
    return modificationTracker.getCreatedDate();
  }

  public User getCreatedBy() {
    return modificationTracker.getCreatedBy();
  }

  public User getLastUpdatedBy() {
    return modificationTracker.getLastUpdatedBy();
  }

  public void setLastUpdated(Date lastUpdated) {
    modificationTracker.setLastUpdated(lastUpdated);
  }

  public void setCreatedDate(Date createdDate) {
    modificationTracker.setCreatedDate(createdDate);
  }

  public void setCreatedBy(User createdBy) {
    modificationTracker.setCreatedBy(createdBy);
  }

  public void setLastUpdatedBy(User lastUpdatedBy) {
    modificationTracker.setLastUpdatedBy(lastUpdatedBy);
  }

  public String toString() {

    if (id == null)
      return null;

    if ((firstName == null || firstName.isEmpty()) &&
        (donorNumber == null || donorNumber.isEmpty())
       )
      return id.toString();

    StringBuilder builder = new StringBuilder();
    builder.append(firstName);
    if (!lastName.isEmpty())
      builder.append(" ").append(lastName);
    builder.append(":").append(donorNumber);

    return builder.toString();
  }

  public String getCallingName() {
    return callingName;
  }

  public void setCallingName(String callingName) {
    this.callingName = callingName;
  }

  public String getNationalID() {
    return nationalID;
  }

  public void setNationalID(String nationalID) {
    this.nationalID = nationalID;
  }

  public Integer getAge() {
    return age;
  }

  public void setAge(Integer age) {
    this.age = age;
  }

  public Boolean getAgeSpecified() {
    return ageSpecified;
  }

  public void setAgeSpecified(Boolean ageSpecified) {
    this.ageSpecified = ageSpecified;
  }
}