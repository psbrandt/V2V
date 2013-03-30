package viewmodel;

import java.util.List;
import java.util.Map;
import java.util.Set;

import model.testresults.TTIStatus;

import repository.bloodtyping.BloodTypingStatus;

public class BloodTestingRuleResult {

  private Set<String> allBloodAboChanges;

  private Set<String> allBloodRhChanges;

  private String bloodAbo;

  private String bloodRh;

  private Set<String> extraInformation;

  private List<String> pendingTestsIds;

  private Map<String, String> availableTestResults;

  private BloodTypingStatus bloodTypingStatus;

  private Map<String, String> storedTestResults;

  // Read about Bean Naming convention in Java
  // http://stackoverflow.com/a/5599478/161628
  // http://www.oracle.com/technetwork/java/javase/documentation/spec-136004.html
  private Set<String> ttiStatusChanges;

  private TTIStatus ttiStatus;

  public BloodTestingRuleResult() {
  }
  
  public Set<String> getAllBloodAboChanges() {
    return allBloodAboChanges;
  }

  public void setAllBloodAboChanges(Set<String> allBloodAboChanges) {
    this.allBloodAboChanges = allBloodAboChanges;
  }

  public Set<String> getAllBloodRhChanges() {
    return allBloodRhChanges;
  }

  public void setAllBloodRhChanges(Set<String> allBloodRhChanges) {
    this.allBloodRhChanges = allBloodRhChanges;
  }

  public String getBloodAbo() {
    return bloodAbo;
  }

  public void setBloodAbo(String bloodAbo) {
    this.bloodAbo = bloodAbo;
  }

  public String getBloodRh() {
    return bloodRh;
  }

  public void setBloodRh(String bloodRh) {
    this.bloodRh = bloodRh;
  }

  public Set<String> getExtraInformation() {
    return extraInformation;
  }

  public void setExtraInformation(Set<String> extraInformation) {
    this.extraInformation = extraInformation;
  }

  public List<String> getPendingTestsIds() {
    return pendingTestsIds;
  }

  public void setPendingTestsIds(List<String> pendingTestsIds) {
    this.pendingTestsIds = pendingTestsIds;
  }

  public Map<String, String> getAvailableTestResults() {
    return availableTestResults;
  }

  public void setAvailableTestResults(Map<String, String> availableTestResults) {
    this.availableTestResults = availableTestResults;
  }

  public BloodTypingStatus getBloodTypingStatus() {
    return bloodTypingStatus;
  }

  public void setBloodTypingStatus(BloodTypingStatus bloodTypingStatus) {
    this.bloodTypingStatus = bloodTypingStatus;
  }

  public Map<String, String> getStoredTestResults() {
    return storedTestResults;
  }

  public void setStoredTestResults(Map<String, String> storedTestResults) {
    this.storedTestResults = storedTestResults;
  }

  public Set<String> getTTIStatusChanges() {
    return ttiStatusChanges;
  }

  public void setTTIStatusChanges(Set<String> ttiStatusChanges) {
    this.ttiStatusChanges = ttiStatusChanges;
  }

  public TTIStatus getTTIStatus() {
    return ttiStatus;
  }

  public void setTTIStatus(TTIStatus ttiStatus) {
    this.ttiStatus = ttiStatus;
  }
}