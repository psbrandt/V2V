package model.collectedsample;

import java.util.Arrays;

import model.CustomDateFormatter;

import org.apache.commons.lang3.StringUtils;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import viewmodel.CollectedSampleViewModel;

import controller.UtilController;

public class CollectedSampleBackingFormValidator implements Validator {

  private Validator validator;
  private UtilController utilController;

  public CollectedSampleBackingFormValidator(Validator validator, UtilController utilController) {
    super();
    this.validator = validator;
    this.utilController = utilController;
  }

  @SuppressWarnings("unchecked")
  @Override
  public boolean supports(Class<?> clazz) {
    return Arrays.asList(FindCollectedSampleBackingForm.class,
                         CollectedSampleBackingForm.class,
                         CollectedSample.class,
                         CollectedSampleViewModel.class,
                         CollectionsWorksheetForm.class
                         ).contains(clazz);
  }

  @Override
  public void validate(Object obj, Errors errors) {
    if (obj == null || validator == null)
      return;

    ValidationUtils.invokeValidator(validator, obj, errors);

    CollectedSampleBackingForm form = (CollectedSampleBackingForm) obj;
    updateAutoGeneratedFields(form);

    String collectedOn = form.getCollectedOn();
    if (!CustomDateFormatter.isDateTimeStringValid(collectedOn))
      errors.rejectValue("collectedSample.collectedOn", "dateFormat.incorrect",
          CustomDateFormatter.getDateTimeErrorMessage());
    utilController.commonFieldChecks(form, "collectedSample", errors);
  }

  private void updateAutoGeneratedFields(CollectedSampleBackingForm form) {
    if (StringUtils.isBlank(form.getCollectionNumber()) &&
        utilController.isFieldAutoGenerated("collectedSample", "collectionNumber")) {
      form.setCollectionNumber(utilController.getNextCollectionNumber());
    }
  }
}
