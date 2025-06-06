<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<sql:setDataSource
  driver="oracle.jdbc.driver.OracleDriver"
  url="jdbc:oracle:thin:@localhost:1521/xepdb1"
  user="user"
  password="password"
/>

<h2>Ergebnisse aller Pr&uuml;fungen</h2>

<c:if test="${empty param.matnr}">
	Es wurde keine Matrikelnummer ausgew&auml;hlt!
</c:if>

<c:if test="${!empty param.matnr}">
	<sql:query var="studenten" 
		sql="select vorname, nachname, matrikelnummer, studienfach, immatrikulationsdatum 
	  		from studenten, personen 
		  	where personen.panr = studenten.panr and matrikelnummer = ?" >
		<sql:param value="${param.matnr}" />
	</sql:query>

	<c:forEach var="student" begin="0" items="${studenten.rows}">
		<p>Pr&uuml;fungsergebnisse f&uuml;r <b>${student.vorname} ${student.nachname}</b>, 
		Matrikelnummer <b>${student.matrikelnummer}</b><br />
		Studienrichtung: <b>${student.studienfach}</b>, 
		immatrikuliert: <b>${student.immatrikulationsdatum}</b>.</p>
		
		<table class="table table-striped table-responsive text-center">
			<thead class="thead-light">
				<tr>
					<th scope="col">Vorlesung</th>
					<th scope="col">Note</th>
					<th scope="col">SWS</th>
					<th scope="col">Pr&uuml;fer</th>
				</tr>
			</thead>
			<tbody>
				<sql:query var="pruefungen" 
					sql="select (pe.vorname||' '||pe.nachname) pruefer, v.v_bezeichnung bezeichnung, note, sws  
				  		from prueft pr, personen pe, vorlesungen v
					  	where pr.panr=pe.panr and pr.v_bezeichnung=v.v_bezeichnung and pr.matrikelnummer = ?" >
					<sql:param value="${param.matnr}" />
				</sql:query>

				<c:forEach var="pruefung" varStatus="status" begin="0" items="${pruefungen.rows}">
					<c:if test="${status.index mod 2 eq 0}">
					<tr>
					</c:if>
					<c:if test="${status.index mod 2 eq 1}">
					<tr>
					</c:if>
		                <td>${pruefung.bezeichnung}</td>
		                <td>${pruefung.note}</td>
		                <td>${pruefung.sws}</td>
		                <td>${pruefung.pruefer}</td>
	                </tr>
				</c:forEach>
			</tbody>
		</table>
			
	</c:forEach>
</c:if>

<br /><a href="index.jsp?menu=noten_anzeigen">Zur&uuml;ck zum Auswahlformular</a>
