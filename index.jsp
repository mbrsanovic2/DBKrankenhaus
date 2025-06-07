<!doctype html>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
		<head>
				<meta charset="utf-8">
				<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">
				<meta name="description" content="">
				<meta name="author" content="Jürgen Falb, Lorenz Froihofer, Dominik Ertl">
		
				<title>Uni - Demo</title>
		
				<!-- Bootstrap core CSS -->
				<link href="css/bootstrap.min.css" rel="stylesheet">
		
				<!-- Custom styles for this template -->
				<link href="css/uni.css" rel="stylesheet">
			</head>
		
			<body>
				<div class="cover-container d-flex align-items-center h-100 p-5 mx-auto flex-column">
					<header class="masthead"><!-- mb-auto -->		
						<div class="inner">
							<h3 class="masthead-brand">Universit&auml;t XY</h3>
							<img class="rounded float-right img-responsive masthead-img" src="images/logo.jpg" alt="logo" title="logo" height="60" style="margin-left: 2rem"/>	

							<nav class="nav navbar-static-top nav-masthead justify-content-center">
								<a class="nav-link ${empty param.menu ? 'active' : ''}" href="index.jsp" id="startmenu">Startseite</a>
								<div class="nav-item dropdown">
										<a class="nav-link dropdown-toggle ${param.menu=='noten_anzeigen' ? 'active' : ''}" href="#" id="exammenu" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
											Pr&uuml;fungsergebnisse
										</a>
										<div class="dropdown-menu" aria-labelledby="exammenu">
											<a class="dropdown-item" href="index.jsp?menu=noten_anzeigen">Pr&uuml;fungsergebnisse anzeigen</a>
										</div>
								</div>
								<div class="nav-item dropdown">
										<a class="nav-link dropdown-toggle ${param.menu=='buch_suchen' or param.menu=='buch_ausleihen' ? 'active' : ''}" href="#" id="bookmenu" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
											B&uuml;cher
										</a>
										<div class="dropdown-menu" aria-labelledby="bookmenu">
												<a class="dropdown-item" href="index.jsp?menu=buch_suchen">Buch suchen</a>
												<a class="dropdown-item" href="index.jsp?menu=buch_ausleihen">Ausgeliehene B&uuml;cher anzeigen</a>
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
					<main role="main" class="inner cover">

						<!-- Session setzen für Ptnr -->
						<%
							if (request.getParameter("ptnr") != null) {
								session.setAttribute("ptnr", request.getParameter("ptnr"));
							}
						%>

							<c:if test="${!empty param.menu}">
								<jsp:include page="${param.menu}.jsp" />
							</c:if>

								<!-- Statische Testdaten für Patientenauswahl -->
								<c:if test="${empty param.menu}">
									<form method="post" action="index.jsp?menu=behandlungen">
										<select name="ptnr">
											<option value="1">Max Muster</option>
											<option value="2">Anna Beispiel</option>
										</select>
										<input type="submit" value="Weiter zur Behandlung" />
									</form>

									<jsp:include page="init.jsp" />
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
