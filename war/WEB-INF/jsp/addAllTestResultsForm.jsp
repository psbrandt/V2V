<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%!public long getCurrentTime() {
		return System.nanoTime();
	}%>

<c:set var="unique_page_id"><%=getCurrentTime()%></c:set>
<c:set var="tabContentId">tabContent-${unique_page_id}</c:set>
<c:set var="editTestResultFormId">editTestResultForm-${unique_page_id}</c:set>
<c:set var="editTestResultFormBarcodeId">editTestResultFormBarcode-${unique_page_id}</c:set>
<c:set var="updateTestResultButtonId">updateTestResultButton-${unique_page_id}</c:set>
<c:set var="bloodTestResultId">bloodTestResultId-${unique_page_id}</c:set>
<c:set var="deleteTestResultButtonId">deleteTestResultButton-${unique_page_id}</c:set>
<c:set var="printButtonId">printButton-${unique_page_id}</c:set>
<c:set var="cancelButtonId">cancelButton-${unique_page_id}</c:set>

<script>
  $(document).ready(
      function() {

        function notifyParentSuccess() {
					 // let the parent know we are done
				   $("#${tabContentId}").parent().trigger("editTestResultSuccess");
   		}

       function notifyParentCancel() {
					 // let the parent know we are done
				   $("#${tabContentId}").parent().trigger("editTestResultCancel");
	   		}

        $("#${cancelButtonId}").button({
          icons : {
            primary : 'ui-icon-closethick'
          }
        }).click(
	           function() {
               notifyParentCancel();
        });

        $("#${updateTestResultButtonId}").button({
          icons : {
            primary : 'ui-icon-plusthick'
          }
        }).click(
            function() {
              addAllTestResults($("#${editTestResultFormId}").serialize(),
               							 "${tabContentId}",
               							 notifyParentSuccess);
            });

        $("#${printButtonId}").button({
          icons : {
            primary : 'ui-icon-print'
          }
        }).click(function() {
          $("#${editTestResultFormId}").printArea();
        });

        $("#${tabContentId}").find(".clearFormButton").button().click(refetchForm);

        function refetchForm() {
          $.ajax({
            url: "${model.refreshUrl}",
            data: {},
            type: "GET",
            success: function (response) {
              			 	 $("#${tabContentId}").replaceWith(response);
            				 },
            error:   function (response) {
											 showErrorMessage("Something went wrong. Please try again.");
            				 }
            
          });
        }

        $("#${editTestResultFormId}").find(".testedOn").datetimepicker({
          changeMonth : true,
          changeYear : true,
          minDate : -36500,
          maxDate : 1,
          dateFormat : "mm/dd/yy",
          timeFormat : "hh:mm:ss tt",
          yearRange : "c-100:c0",
        });

        if ($("#${editTestResultFormId}").find(".testedOn").val() == "")
        	$("#${editTestResultFormId}").find(".testedOn").datepicker('setDate', new Date());

      	$("#${tabContentId}").find('textarea[name="notes"]').html("${model.testResultFields.notes.defaultValue}");

      });
</script>

<div id="${tabContentId}">

	<form method="POST" class="formInTabPane" id="${editTestResultFormId}">
		<c:if test="${model.testResultFields.collectionNumber.hidden != true }">
			<div>
				<label for="collectionNumber">${model.testResultFields.collectionNumber.displayName}</label>
				<input name="collectionNumber" />
				<label class="formError" style="width: 300px;">${model.collectionNumberError}</label>
			</div>
		</c:if>
		<c:if test="${model.testResultFields.testedOn.hidden != true }">
			<div>
				<label for="testedOn">${model.testResultFields.testedOn.displayName}</label>
				<input name="testedOn" class="testedOn" value="${model.testResultFields.testedOn.defaultValue}" />
				<label class="formError" style="width: 300px;">${model.testedOnError}</label>
			</div>
		</c:if>

		<c:forEach var="bloodTest" items="${model.bloodTests}">
			<div>
				<label for="bloodTest">${bloodTest.displayName}</label>
				<c:forEach var="allowedResult" items="${bloodTest.allowedResults}">
					<input id="result-${bloodTest.name}${allowedResult}" type="radio"
								 name="Test${bloodTest.name}" value="${allowedResult}"
								 style="width: 20px;"></input>
					<!-- Specifying the for attribute on label allows clicking on the text to select the radiobutton.
							 accuracy in clicking not required.
					 -->
					<label for="result-${bloodTest.name}${allowedResult}" style="width: 60px; margin-left: 0; margin-right: 10px; cursor: pointer;">${allowedResult}</label>
				</c:forEach>
			</div>
		</c:forEach>
			

		<c:if test="${model.testResultFields.notes.hidden != true }">
			<div>
				<label for="notes" class="labelForTextArea">${model.testResultFields.notes.displayName}</label>
				<textarea name="notes" rows="10" cols="30"></textarea>
			</div>
		</c:if>
	</form>

	<div style="margin-left: 200px;">
		<button type="button" id="${updateTestResultButtonId}">
			Save
		</button>
		<button type="button" class="clearFormButton">
			Clear form
		</button>
		<button type="button" id="${printButtonId}">
			Print
		</button>
	</div>

</div>
