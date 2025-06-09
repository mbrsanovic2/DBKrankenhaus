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

<sql:query var="personen" dataSource="${db}">
	SELECT SVNR, VORNAME, NACHNAME FROM PERSON
</sql:query>

<!-- Abfrage: Patientennummer + Name aus PATIENT und PERSON -->
<!--sql:query var="patienten" dataSource="${db}">
	SELECT ptnr, vorname, nachname
	FROM patient pa
	JOIN person pe ON pa.svnr = pe.svnr
sql:query> -->

<sql:query var="patienten" dataSource="${db}">
	SELECT pa.ptnr, pe.vorname, pe.nachname, pa.svnr
	FROM patient pa
	JOIN person pe ON pa.svnr = pe.svnr
</sql:query>


<html>
		<head>
				<meta charset="utf-8">
				<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">
				<meta name="description" content="">
				<meta name="author" content="J rgen Falb, Lorenz Froihofer, Dominik Ertl">
				<title>Krankenhaus</title>

		
				<!-- Bootstrap core CSS -->
				<link href="bootstrap.min.css" rel="stylesheet">
			</head>

			<%
				String svnr = (String) session.getAttribute("svnr");
				if (svnr == null) {
					// Benutzer ist nicht eingeloggt → redirect oder login zeigen
					response.sendRedirect("index.jsp?menu=login");
					return;
				}
			%>
		
			<body>
				<a href="index.jsp?menu=login" class="btn btn-outline-primary"
			 	  style="position: absolute; top: 20px; left: 20px; z-index: 1000;">
					Login
				</a>
				<!-- Navigation -->
				<div class="cover-container d-flex align-items-center h-100 p-5 mx-auto flex-column">
					<header class="masthead"><!-- mb-auto -->		
						<div class="inner">
							<h3 class="masthead-brand">Krankenhaus HeileWelt</h3>
							<img class="rounded float-right img-responsive masthead-img" src="HeileWelt.png" alt="logo" title="logo" height="100" style="margin-left: 2rem"/>

							<nav class="nav navbar-static-top nav-masthead justify-content-center">
								<a class="nav-link ${empty param.menu ? 'active' : ''}" href="index.jsp" id="startmenu">Startseite</a>

								<a class="nav-link ${param.menu=='patienten'}" href="index.jsp?menu=patienten" id="anlegen">Patienten anlegen</a>

								<a class="nav-link ${param.menu=='behandlungen'}" href="index.jsp?menu=behandlungen" id="behandlungen">Behandlungen anzeigen</a>
						</nav>
							
						</div>
					 </header>
					<c:if test="${empty param.menu}">
						<jsp:include page="init.jsp" />
					</c:if>

					<main role="main" class="inner cover">

						<!-- Session setzen für Ptnr -->
						<%
							String ptnr = request.getParameter("ptnr");
							if (ptnr != null && !ptnr.isEmpty()) {
								session.setAttribute("ptnr", ptnr);
							}
						%>

							<c:if test="${!empty param.menu}">
								<jsp:include page="${param.menu}.jsp" />
							</c:if>

								<!-- Statische Testdaten für Patientenauswahl -->
								<c:if test="${empty param.menu}">
									<!-- Dropdown zur Auswahl eines Patienten -->
									<p>Patientenanzahl: <c:out value="${fn:length(patienten.rows)}"/></p>

									<form method="post" action="index.jsp?menu=behandlungen">
										<div class="form-group">
											<label for="ptnr">Bitte w&auml;hlen Sie einen Patienten:</label>
											<select class="form-control" id="ptnr" name="ptnr" required>
												<option value="" ${sessionScope.ptnr == null ? 'selected' : ''}>-- Bitte w&auml;hlen --</option>

												<c:forEach var="p" items="${patienten.rows}">
													<option value="${p.ptnr}" ${p.ptnr == sessionScope.ptnr ? 'selected' : ''}>
														${p.ptnr} ${p.vorname} ${p.nachname}
													</option>
												</c:forEach>
											</select>
										</div>
										<button type="submit" class="btn btn-primary">Weiter zur Behandlung</button>
									</form>

									<!-- Suchfeld -->
									<form method="get" action="index.jsp" class="form-inline mt-3">
										<input type="text" name="suchbegriff" class="form-control mr-2" placeholder="Nachname suchen..." value="${param.suchbegriff}">
										<button type="submit" class="btn btn-primary">Suchen</button>
									</form>

									<!-- Personenliste -->
									<h4 class="mt-4">Alle Patienten</h4>
									<div class="border rounded p-3" style="max-height: 300px; overflow-y: auto;">
										<table class="table table-sm table-striped table-hover">
											<thead class="thead-dark">
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


									<c:if test="${sessionScope.arname != null}">
										<br>
										<div style="border: 1px solid rgb(0, 0, 0); padding: 5px 5px; background-color:rgb(229, 246, 252);">
											<h6>Zuletzt angelegte Behandlung:</h6>
											<p style="margin: 0;">
												Arzt: Dr. <%= session.getAttribute("arname") %><br>
												Patient: <%= session.getAttribute("ptnr") %><br>
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