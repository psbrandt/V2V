<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<script src="js/topPanel.js" type="text/javascript"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<div id="v2vHeading">
	<a href="/v2v">VEIN-TO-VEIN</a>
</div>
<div class="headlink">
	<p class="topPanelUsername">
		Logged in as ${model.user.username} |

		<c:choose>
			<c:when test="${model.user.type=='admin'}">
				<a href="admin-findUser.html?username=${model.user.username}"
					class="topPanelLink"> Edit Profile</a>
			</c:when>
			<c:otherwise>
				<a href="findUser.html?username=${model.user.username}"> Edit
					Profile</a>
			</c:otherwise>
		</c:choose>

	</p>
	<c:if test="${model.user.type=='admin'}">
		<a href="admin-locationTypesLandingPage.html">Work As Admin</a>
	</c:if>
	<a href="logout.html">Logout</a>
</div>

<div id="topPanelTabs" class="topPanelTabs">
	<ul id="topTabs">
		<li class="topPanelTab"><a href="#homeLandingPageContent">Home</a></li>
		<li class="topPanelTab"><a href="#donorsLandingPageContent">Donors</a></li>
		<li class="topPanelTab"><a href="collectionsLandingPage.html">Collections</a></li>
		<li class="topPanelTab"><a href="testResultsLandingPage.html">Test
				Results</a></li>
		<li class="topPanelTab"><a href="productsLandingPage.html">Products</a></li>
		<li class="topPanelTab"><a href="requestsLandingPage.html">Request</a></li>
		<li class="topPanelTab"><a href="issueLandingPage.html">Issue</a></li>
		<li class="topPanelTab"><a href="usageLandingPage.html">Usage</a></li>
		<li class="topPanelTab"><a href="reports.html">Reports</a></li>
	</ul>

	<div id="homeLandingPageContent">
		<h2>Welcome to Vein-To-Vein</h2>
		<div class="infoMessage">
			Vein-to-Vein (V2V) is a system to monitor and analyze data from blood
			collection, testing, and utilization. This is an initiative of the
			Compute For Good (C4G) program at the Georgia Institute of Technology
			in collaboration with the Center for Disease Control and Prevention
			(CDC). <br /> <br /> See <a
				href="http://www.cc.gatech.edu/about/advancing/c4g/" target="_blank">
				http://www.cc.gatech.edu/about/advancing/c4g/ </a> for more information.
		</div>
	</div>

	<div id="donorsLandingPageContent">
		<jsp:include page="donors.jsp"/>
	</div>

</div>