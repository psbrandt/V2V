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
<c:set var="table_id">requestsTable-${unique_page_id}</c:set>
<c:set var="requestsTableEditRowDivId">requestsTableEditRowDiv-${unique_page_id}</c:set>

<script>
$(document).ready(
    function() {

      var requestsTable = $("#${table_id}").dataTable({
        "bJQueryUI" : true,
        "sDom" : 'C<"H"lfrT>t<"F"ip>T',
        "aoColumnDefs" :  [{ "sClass" : "hide_class", "aTargets": [0]}
        									],
        "oTableTools" : {
          "sRowSelect" : "single",
          "aButtons" : [],
          "fnRowSelected" : function(node) {
															$("#${tabContentId}").parent().trigger("requestSummaryView");
											        var elements = $(node).children();
											        if (elements[0].getAttribute("class") === "dataTables_empty") {
											          return;
											        }
											        var selectedRowId = elements[0].innerHTML;
											        createRequestSummary("requestSummary.html",
									  							{requestId: selectedRowId});
 													  },
		  		"fnRowDeselected" : function(node) {},
        },
        "sPaginationType" : "full_numbers"
      });

      function createRequestSummary(url, data) {
        $.ajax({
          url: url,
          data: data,
          type: "GET",
          success: function(response) {
            				 $("#${tabContentId}").trigger("requestSummaryView", response);
            			 }
        });
      }

      function refreshResults() {
        showLoadingImage($("#${tabContentId}"));
        $.ajax({url: "${refreshUrl}",
          			data: {},
          			type: "GET",
          			success: function(response) {
          			  				 $("#${tabContentId}").html(response);
          							 }
        });
      }

      $("#${tabContentId}").find(".requestsTable").bind("refreshResults", refreshResults);

      $("#${table_id}_filter").find("label").find("input").keyup(function() {
        var searchBox = $("#${table_id}_filter").find("label").find("input");
        $("#${table_id}").removeHighlight();
        if (searchBox.val() != "")
          $("#${table_id}").find("td").highlight(searchBox.val());
      });

    });
</script>

<div id="${tabContentId}">

	<c:choose>

		<c:when test="${fn:length(allRequests) eq 0}">
			<span
				style="font-style: italic; font-size: 14pt; margin-top: 30px; display: block;">
				Sorry no results found matching your search request </span>
		</c:when>

		<c:otherwise>

			<table id="${table_id}" class="dataTable requestsTable">
				<thead>
					<tr>
						<th style="display: none"></th>
						<c:if test="${requestFields.bloodAbo.hidden != true}">
							<th>${requestFields.patientBloodAbo.displayName}</th>
						</c:if>
						<c:if test="${requestFields.bloodRh.hidden != true}">
							<th>${requestFields.patientBloodRh.displayName}</th>
						</c:if>
						<c:if test="${requestFields.requestDate.hidden != true}">
							<th>${requestFields.requestDate.displayName}</th>
						</c:if>
						<c:if test="${requestFields.requiredDate.hidden != true}">
							<th>${requestFields.requiredDate.displayName}</th>
						</c:if>
						<c:if test="${requestFields.productType.hidden != true}">
							<th>${requestFields.productType.displayName}</th>
						</c:if>
						<c:if test="${requestFields.numUnitsRequested.hidden != true}">
							<th>${requestFields.numUnitsRequested.displayName}</th>
						</c:if>
						<c:if test="${requestFields.numUnitsIssued.hidden != true}">
							<th>${requestFields.numUnitsIssued.displayName}</th>
						</c:if>
						<c:if test="${requestFields.requestSite.hidden != true}">
							<th>${requestFields.requestSite.displayName}</th>
						</c:if>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="request" items="${allRequests}">
						<tr>
							<td style="display: none">${request.id}</td>
							<c:if test="${requestFields.patientBloodAbo.hidden != true}">
								<td>${request.patientBloodAbo}</td>
							</c:if>
							<c:if test="${requestFields.patientBloodRh.hidden != true}">
								<td>${request.patientBloodRh eq '+' ? 'POS' : request.patientBloodRh eq '-' ? 'NEG' : ''}</td>
							</c:if>
							<c:if test="${requestFields.requestDate.hidden != true}">
								<td>${request.requestDate}</td>
							</c:if>
							<c:if test="${requestFields.requiredDate.hidden != true}">
								<td>${request.requiredDate}</td>
							</c:if>
							<c:if test="${requestFields.productType.hidden != true}">
								<td>${request.productType.productTypeNameShort}</td>
							</c:if>
							<c:if test="${requestFields.numUnitsRequested.hidden != true}">
								<td>${request.numUnitsRequested}</td>
							</c:if>
							<c:if test="${requestFields.numUnitsIssued.hidden != true}">
								<td>${request.numUnitsIssued}</td>
							</c:if>
							<c:if test="${requestFields.requestSite.hidden != true}">
								<td>${request.requestSite}</td>
							</c:if>
						</tr>
					</c:forEach>
				</tbody>
			</table>

		</c:otherwise>
	</c:choose>

</div>
