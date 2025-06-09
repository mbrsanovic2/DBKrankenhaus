<!doctype html>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>



<sql:setDataSource
		var="db"
		driver="oracle.jdbc.OracleDriver"
		url="jdbc:oracle:thin:@localhost:1521/xepdb1"
		user="system"
		password="password"
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
	SELECT pa.ptnr, pe.vorname, pe.nachname
	FROM patient pa
	JOIN person pe ON pa.svnr = pe.svnr
</sql:query>


<html>
		<head>
				<meta charset="utf-8">
				<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">
				<meta name="description" content="">
				<meta name="author" content="J�rgen Falb, Lorenz Froihofer, Dominik Ertl">
				<title>Krankenhaus</title>

		
				<!-- Bootstrap core CSS -->
				<link href="css/bootstrap.min.css" rel="stylesheet">
		
				<!-- Custom styles for this template -->
				<link href="css/uni.css" rel="stylesheet">
			</head>
		
			<body>
				<a href="login.jsp" class="btn btn-outline-primary"
			 	  style="position: absolute; top: 20px; left: 20px; z-index: 1000;">
					Login
				</a>
				<!-- Navigation -->
				<div class="cover-container d-flex align-items-center h-100 p-5 mx-auto flex-column">
					<header class="masthead"><!-- mb-auto -->		
						<div class="inner">
							<h3 class="masthead-brand">Krankenhaus HeileWelt</h3>
							<img class="rounded float-right img-responsive masthead-img" src="images/HeileWelt.png" alt="logo" title="logo" height="100" style="margin-left: 2rem"/>

							<nav class="nav navbar-static-top nav-masthead justify-content-center">
								<a class="nav-link ${empty param.menu ? 'active' : ''}" href="index.jsp" id="startmenu">Startseite</a>

								<div class="nav-item dropdown">
									<a class="nav-link dropdown-toggle ${param.menu=='patienten'}" href="#" id="patienten" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
										Patienten
									</a>
									<div class="dropdown-menu" aria-labelledby="patienten">
										<a class="dropdown-item" href="index.jsp?menu=patienten">Patienten anlegen</a>
									</div>
								</div>
								<div class="nav-item dropdown">
										<a class="nav-link dropdown-toggle ${param.menu=='behandlungen'}" href="#" id="behandlungen" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
											Behandlungen
										</a>
										<div class="dropdown-menu" aria-labelledby="behandlungen">
												<a class="dropdown-item" href="index.jsp?menu=behandlungen">Behandlungen anzeigen</a>
										</div>
								</div>

						</nav>
							
						</div>
					 </header>

					<jsp:include page="init.jsp" />

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
											<c:forEach var="person" items="${personen.rows}">
												<c:set var="suchbegriff" value="${fn:toLowerCase(param.suchbegriff)}" />
												<c:set var="nachnameKlein" value="${fn:toLowerCase(person.NACHNAME)}" />
												<c:if test="${empty param.suchbegriff or fn:contains(nachnameKlein, suchbegriff)}">
													<tr>
														<td><c:out value="${person.SVNR}" /></td>
														<td><c:out value="${person.VORNAME}" /></td>
														<td><c:out value="${person.NACHNAME}" /></td>
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
												Arzt: <%= session.getAttribute("arname") %><br>
												Patient: <%= session.getAttribute("ptnr") %><br>
												Datum: <%= session.getAttribute("letzteBehandlung_datum") %><br>
												Zeit: <%= session.getAttribute("letzteBehandlung_tzeit") %>
											</p>
										</div>
									</c:if>
								</c:if>

					</main>
		
					<footer class="mastfoot mt-auto text-center">
						<div class="inner">
						    <p><a href="mailto:wbt@dedisys.org" class="nav-link">
							    Kontaktieren Sie uns:
							    <img class="rounded img-responsive mastfoot-img" src="images/email.jpg" alt="contact us" title="contact us" />
						        </a>
						    </p>
						</div>
					</footer>
				</div>


				<!-- Bootstrap core JavaScript
				================================================== -->
				<!-- Placed at the end of the document so the pages load faster -->
				<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
				<script>window.jQuery || document.write('<script src="js/vendor/jquery-3.3.1.slim.min.js"><\/script>')</script>
				<script src="js/vendor/popper.min.js"></script>
				<script src="js/bootstrap.min.js"></script>
	    </body>
</html>