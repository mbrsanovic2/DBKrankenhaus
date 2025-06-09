<!doctype html>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<sql:setDataSource
    var="db"
    driver="oracle.jdbc.driver.OracleDriver"
    url="jdbc:oracle:thin:@localhost:1521/xepdb1"
    user="csdc26bb_03"
    password="urieGoo7la"
/>
<!-- LOKALE USERDATEN
  user="system"
  password="password"
-->

<sql:query var="personen" dataSource="${db}">
	SELECT SVNR, VORNAME, NACHNAME FROM PERSON
</sql:query>

<sql:query var="patienten" dataSource="${db}">
	SELECT pa.ptnr, pe.vorname, pe.nachname, pa.svnr
	FROM patient pa
	JOIN person pe ON pa.svnr = pe.svnr
</sql:query>

<sql:query var="ptname" dataSource="${db}">
	SELECT pe.vorname, pe.nachname
	FROM patient pa
	JOIN person pe ON pa.svnr = pe.svnr
	WHERE pa.PtNr = ?
    <sql:param value="${sessionScope.letzteBehandlung_ptnr}" />
</sql:query>

<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">
		<meta name="description" content="">
		<meta name="author" content="Elisabeth Wegscheider, Julian Schmitt, Konstantin Köfler, Mihael Brsanovic, Corinna Pucher">
		<title>Krankenhaus</title>
		<link href="kh.css" rel="stylesheet">
		<link href="bootstrap.min.css" rel="stylesheet">
	</head>

	<!-- Session setzen für Patientennummer -->
	<%
		String ptnr = request.getParameter("ptnr");
		if (ptnr != null && !ptnr.isEmpty()) {
			session.setAttribute("ptnr", ptnr);
		}
	%>

	<%
		/**
		String svnr = (String) session.getAttribute("svnr");
		if (svnr == null) {
			// Benutzer ist nicht eingeloggt → redirect oder login zeigen
			response.sendRedirect("index.jsp?menu=login");
			return;
		}
		**/
	%>

	<body>
		<a href="index.jsp?menu=login" class="btn btn-outline-primary"
			style="position: absolute; top: 20px; left: 20px; z-index: 1000;">
			Login
		</a>
		<!-- Navigation -->
		<div class="d-flex align-items-center h-100 p-5 mx-auto flex-column">
			<header class="masthead">		
				<div class="container d-flex justify-content-start align-items-end">
					<img class="masthead-img" src="HeileWelt_Logo.png" alt="logo" title="logo"/>

					<nav class="nav navbar-static-top nav-masthead justify-content-center">
						<a class="nav-link ${empty param.menu ? 'active' : ''}" href="index.jsp" id="startmenu">Startseite</a>
						<a class="nav-link ${param.menu=='patienten'}" href="index.jsp?menu=patienten" id="anlegen">Patienten anlegen</a>
						<a class="nav-link ${param.menu=='behandlungen'}" href="index.jsp?menu=behandlungen" id="behandlungen">Behandlungen anzeigen</a>
					</nav>
				</div>
			</header>

			<main role="main" style="width: 50%; max-width: 712px;">
				<!-- Willkommensnachricht auf Startseite anzeigen -->
				<c:if test="${empty param.menu}">
					<jsp:include page="init.jsp" />
					<hr>
				</c:if>

				<!-- Unterseiten anzeigen: Login, Patienten anlegen, Behandlungen anzeigen -->
				<c:if test="${!empty param.menu}">
					<jsp:include page="${param.menu}.jsp" />
				</c:if>

				<!-- Patientenauswahl auf Startseite -->
				<c:if test="${empty param.menu}">
					<p>Patientenanzahl: <c:out value="${fn:length(patienten.rows)}"/></p>

					<form method="post" action="index.jsp?menu=behandlungen" class="d-flex align-items-end">
						<div class="form-group">
							<label for="ptnr">Bitte w&auml;hlen Sie einen Patienten:</label>
							<select class="form-control mt-3" id="ptnr" name="ptnr" required>
								<option value="" ${sessionScope.ptnr == null ? 'selected' : ''}>-- Bitte w&auml;hlen --</option>

								<c:forEach var="p" items="${patienten.rows}">
									<option value="${p.ptnr}" ${p.ptnr == sessionScope.ptnr ? 'selected' : ''}>
										${p.ptnr} ${p.vorname} ${p.nachname}
									</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group" style="margin-left: 8px;">
							<button type="submit" class="btn btn-primary ml-4">Weiter zur Behandlung</button>
						</div>
					</form>

					<hr>

					<!-- Patientenliste auf Startseite-->
					<h4>Alle Patienten</h4>

					<form method="get" action="index.jsp" class="form-inline mt-3">
						<input type="text" name="suchbegriff" class="form-control mr-2" placeholder="Nachname suchen..." value="${param.suchbegriff}">
						<button type="submit" class="btn btn-primary ml-4">Suchen</button>
					</form>

					<br>

					<div class="" style="max-height: 300px; overflow-y: auto;">
						<table class="table table-hover table-sm">
							<thead class="thead-light">
							<tr>
								<th>SVNR</th>
								<th>Vorname</th>
								<th>Nachname</th>
							</tr>
							</thead>
							<tbody>
							<c:forEach var="patient" items="${patienten.rows}">
								<c:set var="suchbegriff" value="${fn:toLowerCase(param.suchbegriff)}" />
								<c:set var="nachnameKlein" value="${fn:toLowerCase(patient.NACHNAME)}" />
								<c:if test="${empty param.suchbegriff or fn:contains(nachnameKlein, suchbegriff)}">
									<tr>
										<td><c:out value="${patient.SVNR}" /></td>
										<td><c:out value="${patient.VORNAME}" /></td>
										<td><c:out value="${patient.NACHNAME}" /></td>
									</tr>
								</c:if>
							</c:forEach>
							</tbody>
						</table>
					</div>

					<!-- Newsfeed: Zuletzt zugewiesene Behandlung -->
					<c:if test="${sessionScope.letzteBehandlung_datum != null}">
						<br>
						<div style="border: 1px solid rgb(0, 0, 0); padding: 5px 5px; background-color:rgb(229, 246, 252);">
							<h6>Zuletzt angelegte Behandlung:</h6>
							<p style="margin: 0;">
								Arzt: Dr. <%= session.getAttribute("arname") %><br>
								Patient: <c:out value="${ptname.rows[0].nachname}" /> <c:out value="${ptname.rows[0].vorname}" /><br>
								Datum: <%= session.getAttribute("letzteBehandlung_datum") %><br>
								Zeit: <%= session.getAttribute("letzteBehandlung_tzeit") %>
							</p>
						</div>
					</c:if>
				</c:if>
			</main>
		</div>
	</body>
</html>