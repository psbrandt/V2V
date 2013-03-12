package model.donordeferral;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class DeferralReason {

  @Id
  @GeneratedValue(strategy = GenerationType.AUTO)
  @Column(nullable=false, updatable=false, insertable=false)
  private Long id;

  @Column(length=50)
  private String reason;

  @Column(length=255)
  private String details;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getReason() {
    return reason;
  }

  public void setReason(String reason) {
    this.reason = reason;
  }

  public String getDetails() {
    return details;
  }

  public void setDetails(String details) {
    this.details = details;
  }
}
