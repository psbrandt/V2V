<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%!public long getCurrentTime() {
		return System.nanoTime();
	}%>

<c:set var="unique_page_id"><%=getCurrentTime()%></c:set>
<c:set var="tabContentId">tableContent-${unique_page_id}</c:set>
<c:set var="table_id">testResultsTable-${unique_page_id}</c:set>
<c:set var="childContentId">childContentId-${unique_page_id}</c:set>

<c:set var="testResultsTableEditRowDivId">testResultsTableEditRowDiv-${unique_page_id}</c:set>
<c:set var="deleteTestResultConfirmDialogId">deleteTestResultConfirmDialog-${unique_page_id}</c:set>

<script>
$(document).ready(
    function() {

      var selectedRowId = null;
      var testResultsTable = $("#${table_id}").dataTable({
        "bJQueryUI" : true,
        "sDom" : 'C<"H"lfrT>t<"F"ip>T',
        "oTableTools" : {
          "sRowSelect" : "single",
          "aButtons" : [ "print" ],
          "fnRowSelected" : function(node) {
														},
					"fnRowDeselected" : function(node) {
															},
        },
        "oColVis" : {
         	"aiExclude": [0,1],
        }
      });

      $("#${tabContentId}").find(".doneButton").button(
          	{
          	  icons: {
          	    			 primary: 'ui-icon-check'
          	    		 }
          	}).click(function() {
        				$("#${tabContentId}").parent().trigger("testResultsHistorySuccess");
      				 });

    });
</script>

<div id="${tabContentId}">

	<button type="button" class="doneButton">
		Done
	</button>

	<br />
	<br />

	<c:choose>

		<c:when test="${fn:length(model.allTestResults) eq 0}">
			<span
				style="font-style: italic; font-size: 14pt; margin-top: 30px; display: block;">
				Sorry no results found matching your search request </span>
		</c:when>

		<c:otherwise>

			<table id="${table_id}" class="dataTable testResultsTable">
				<thead>
					<tr>
						<th style="display: none"></th>
						<c:if test="${model.testResultFields.collectionNumber.hidden != true}">
							<th>${model.testResultFields.collectionNumber.displayName}</th>
						</c:if>
						<c:if test="${model.testResultFields.testedOn.hidden != true}">
							<th>${model.testResultFields.testedOn.displayName}</th>
						</c:if>
						<c:if test="${model.testResultFields.bloodTest.hidden != true}">
							<th>${model.testResultFields.bloodTest.displayName}</th>
						</c:if>
						<c:if test="${model.testResultFields.result.hidden != true}">
							<th>${model.testResultFields.result.displayName}</th>
						</c:if>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="testResult" items="${model.allTestResults}">
						<tr>
							<td style="display: none">${testResult.id}</td>
							<c:if test="${model.testResultFields.collectionNumber.hidden != true}">
								<td>${testResult.collectedSample.collectionNumber}</td>
							</c:if>
							<c:if test="${model.testResultFields.testedOn.hidden != true}">
								<td>${testResult.testedOn}</td>
							</c:if>
							<c:if test="${model.testResultFields.bloodTest.hidden != true}">
								<td>${testResult.bloodTest.name}</td>
							</c:if>
							<c:if test="${model.testResultFields.result.hidden != true}">
								<td>${testResult.result}</td>
							</c:if>
						</tr>
					</c:forEach>
				</tbody>
			</table>

		</c:otherwise>
	</c:choose>

</div>
