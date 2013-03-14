<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%!public long getCurrentTime() {
		return System.nanoTime();
	}%>

<c:set var="unique_page_id"><%=getCurrentTime()%></c:set>
<c:set var="tabContentId">tabContent-${unique_page_id}</c:set>
<c:set var="addCollectionFormId">addCollectionForm-${unique_page_id}</c:set>
<c:set var="addCollectionFormBarcodeId">addCollectionFormBarcode-${unique_page_id}</c:set>
<c:set var="addCollectionFormDonorId">addCollectionFormDonor-${unique_page_id}</c:set>
<c:set var="addCollectionFormDonorHiddenId">addCollectionFormDonorHidden-${unique_page_id}</c:set>
<c:set var="addCollectionFormCentersId">addCollectionFormCenters-${unique_page_id}</c:set>
<c:set var="addCollectionFormSitesId">addCollectionFormSites-${unique_page_id}</c:set>
<c:set var="addCollectionFormBloodBagTypeId">addCollectionFormBloodBagType-${unique_page_id}</c:set>
<c:set var="addCollectionFormDonationTypeId">addCollectionFormDonationType-${unique_page_id}</c:set>
<c:set var="updateCollectedSampleButtonId">updateCollectedSampleButton-${unique_page_id}</c:set>
<c:set var="cancelCollectedSampleButtonId">cancelCollectedSampleButton-${unique_page_id}</c:set>
<c:set var="deleteCollectedSampleButtonId">deleteCollectedSampleButton-${unique_page_id}</c:set>
<c:set var="printButtonId">printButton-${unique_page_id}</c:set>

<script>
  $(document).ready(
      function() {

        function notifyParentSuccess() {
						// let the parent know we are done
						$("#${tabContentId}").parent().trigger("editCollectionSuccess");
				}
  
        function notifyParentCancel() {
	        $("#${tabContentId}").parent().trigger("editCollectionCancel");
        }

        $("#${tabContentId}").find(".cancelButton").button({
          icons : {
            primary : 'ui-icon-closethick'
          }
        }).click(notifyParentCancel);

        $("#${updateCollectedSampleButtonId}").button({
          icons : {
            primary : 'ui-icon-plusthick'
          }
        }).click(
            function() {
                addNewCollection($("#${addCollectionFormId}")[0],
                    									"${tabContentId}", notifyParentSuccess);
            });

        $("#${printButtonId}").button({
          icons : {
            primary : 'ui-icon-print'
          }
        }).click(function() {
          $("#${addCollectionFormId}").printArea();
        });

        $("#${addCollectionFormCentersId}").multiselect({
          multiple : false,
          selectedList : 1,
          header : false
        });

        $("#${addCollectionFormSitesId}").multiselect({
          multiple : false,
          selectedList : 1,
          header : false
        });

        $("#${addCollectionFormBloodBagTypeId}").multiselect({
          multiple : false,
          selectedList : 1,
          header : false
        });

        $("#${addCollectionFormDonationTypeId}").multiselect({
          multiple : false,
          selectedList : 1,
          header : false
        });

        $("#${addCollectionFormId}").find(".collectedOn").datetimepicker({
          changeMonth : true,
          changeYear : true,
          minDate : -36500,
          maxDate : 1,
          dateFormat : "mm/dd/yy",
          timeFormat : "hh:mm:ss tt",
          yearRange : "c-100:c0",
        });

//        var collectedOnDatePicker = $("#${addCollectionFormId}").find(".collectedOn");
//        if ("${existingCollectedSample}" == "false" && collectedOnDatePicker.val() == "") {
//          collectedOnDatePicker.datepicker('setDate', new Date());
//        }

        $("#${tabContentId}").find(".clearFormButton").button({
          icons : {
            
          }
        }).click(refetchForm);

        function refetchForm() {
          $.ajax({
            url: "${refreshUrl}",
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

        if ("${disallowDonorChange}" == "true") {
	        $("#${addCollectionFormId}").find('input[name="donorNumber"]').attr("readonly", "readonly");	
        }

        function updateBarcode(val) {
          if (val === null || val === undefined || val === "")
            val = "-";
	        $("#${addCollectionFormId}").find(".barcodeContainer").barcode(
						  val,
							"code128",
							{barWidth: 2, barHeight: 50, fontSize: 15, output: "css"});
        }
        updateBarcode("${addCollectionForm.collectedSample.collectionNumber}");

        $("#${addCollectionFormId}").find('input[name="collectionNumber"]').keyup(function() {
          updateBarcode($(this).val());
        });
        
        if ("${firstTimeRender}" == "true") {
          // just set the default values for the new collection  
        	$("#${tabContentId}").find('textarea[name="notes"]').html("${collectionFields.notes.defaultValue}");
        	setDefaultValueForSelector(getDonationTypeSelector(), "${collectionFields.donationType.defaultValue}");
        	setDefaultValueForSelector(getCollectionCenterSelector(), "${collectionFields.collectionCenter.defaultValue}");
        	setDefaultValueForSelector(getBloodBagTypeSelector(), "${collectionFields.bloodBagType.defaultValue}");
        	setDefaultValueForSelector(getCollectionSiteSelector(), "${collectionFields.collectionSite.defaultValue}");
        }

        function getDonationTypeSelector() {
          return $("#${tabContentId}").find('select[name="donationType"]').multiselect();
        }

        function getCollectionCenterSelector() {
          return $("#${tabContentId}").find('select[name="collectionCenter"]').multiselect();
        }

        function getBloodBagTypeSelector() {
          return $("#${tabContentId}").find('select[name="bloodBagType"]').multiselect();
        }

        function getCollectionSiteSelector() {
          return $("#${tabContentId}").find('select[name="collectionSite"]').multiselect();
        }

		});
</script>

<div id="${tabContentId}">

	<form:form method="POST" commandName="addCollectionForm"
		class="formInTabPane" id="${addCollectionFormId}">
		<form:hidden path="id" />
		<c:if test="${!collectionFields.collectionNumber.autoGenerate}">
			<c:if test="${collectionFields.collectionNumber.hidden != true }">
				<div class="barcodeContainer"></div>
				<div>
					<form:label path="collectionNumber">${collectionFields.collectionNumber.displayName}</form:label>
					<form:input path="collectionNumber" value="${firstTimeRender ? collectionFields.collectionNumber.defaultValue : ''}" />
					<form:errors class="formError"
						path="collectedSample.collectionNumber" delimiter=", "></form:errors>
				</div>
			</c:if>
		</c:if>
		<c:if test="${collectionFields.donor.hidden != true }">
			<div>
				<form:label path="donorNumber">${collectionFields.donorNumber.displayName}</form:label>
				<form:hidden path="donorIdHidden" />
				<form:input path="donorNumber" class="donorNumber" value="${firstTimeRender ? collectionFields.donorNumber.defaultValue : ''}" />
				<form:errors class="formError" path="collectedSample.donorNumber"
					delimiter=", "></form:errors>
				<form:errors class="formError" path="collectedSample.donor"
					delimiter=", "></form:errors>
			</div>
		</c:if>
		<c:if test="${collectionFields.collectedOn.hidden != true }">
			<div>
				<form:label path="collectedOn">${collectionFields.collectedOn.displayName}</form:label>
				<form:input path="collectedOn" class="collectedOn" value="${firstTimeRender ? collectionFields.collectedOn.defaultValue : ''}" />
				<form:errors class="formError" path="collectedSample.collectedOn"
					delimiter=", "></form:errors>
			</div>
		</c:if>
		<c:if test="${collectionFields.donationType.hidden != true }">
			<div>
				<form:label path="donationType">${collectionFields.donationType.displayName}</form:label>
				<form:select path="donationType"
					id="${addCollectionFormDonationTypeId}"
					class="addCollectionFormDonationType">
					<form:option value="">&nbsp;</form:option>
					<c:forEach var="donationType" items="${donationTypes}">
						<form:option value="${donationType.id}">${donationType.donationType}</form:option>
					</c:forEach>
				</form:select>
				<form:errors class="formError" path="collectedSample.donationType"
					delimiter=", "></form:errors>
			</div>
		</c:if>
		<c:if test="${collectionFields.collectionCenter.hidden != true }">
			<div>
				<form:label path="collectionCenter">${collectionFields.collectionCenter.displayName}</form:label>
				<form:select path="collectionCenter" id="${addCollectionFormCentersId}" class="addCollectionFormCenters">
					<form:option value="" selected="selected">&nbsp;</form:option>
					<c:forEach var="center" items="${centers}">
						<form:option value="${center.id}">${center.name}</form:option>
					</c:forEach>
				</form:select>
				<form:errors class="formError" path="collectedSample.collectionCenter" delimiter=", "></form:errors>
			</div>
		</c:if>
		<c:if test="${collectionFields.bloodBagType.hidden != true }">
			<div>
				<form:label path="bloodBagType">${collectionFields.bloodBagType.displayName}</form:label>
				<form:select path="bloodBagType"
					id="${addCollectionFormBloodBagTypeId}">
					<form:option value="">&nbsp;</form:option>
					<c:forEach var="bloodBagType" items="${bloodBagTypes}">
						<form:option value="${bloodBagType.id}">${bloodBagType.bloodBagType}</form:option>
					</c:forEach>
				</form:select>
				<form:errors class="formError" path="collectedSample.bloodBagType"
					delimiter=", "></form:errors>
			</div>
		</c:if>
		<c:if test="${collectionFields.site.hidden != true }">
			<div>
				<form:label path="collectionSite">${collectionFields.collectionSite.displayName}</form:label>
				<form:select path="collectionSite" id="${addCollectionFormSitesId}"
					class="addCollectionFormSites">
					<form:option value="" selected="selected">&nbsp;</form:option>
					<c:forEach var="site" items="${sites}">
						<form:option value="${site.id}">${site.name}</form:option>
					</c:forEach>
				</form:select>
				<form:errors class="formError" path="collectedSample.collectionSite" delimiter=", "></form:errors>
			</div>
		</c:if>
		<c:if test="${collectionFields.notes.hidden != true }">
			<div>
				<form:label path="notes" class="labelForTextArea">${collectionFields.notes.displayName}</form:label>
				<form:textarea path="notes" />
				<form:errors class="formError" path="collectedSample.notes"
					delimiter=", "></form:errors>
			</div>
		</c:if>
		</form:form>

		<div style="margin-left: 200px;">
			<c:if test="${!(existingCollectedSample)}">
				<button type="button" id="${updateCollectedSampleButtonId}" class="autoWidthButton">
					Save
				</button>
				<c:if test="${collectionForDonor}">
					<button type="button" class="cancelButton">
						Cancel
					</button>
				</c:if>
				<button type="button" class="clearFormButton autoWidthButton">
					Clear form
				</button>				
			</c:if>
			<c:if test="${existingCollectedSample}">
				<button type="button" id="${updateCollectedSampleButtonId}">
					Save
				</button>
				<button type="button" class="cancelButton">
					Cancel
				</button>
			</c:if>
			<button type="button" id="${printButtonId}">
				Print
			</button>
		</div>

</div>
