<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<sql:setDataSource
  driver="oracle.jdbc.driver.OracleDriver"
  url="jdbc:oracle:thin:@localhost:1521/xepdb1"
  user="user"
  password="password"
/>

<h2>B&uuml;cher suchen</h2>
<p>
Bitte geben Sie die Suchparameter ein und dr&uuml;cken Sie "Suchen...".</p>
<p><h5>Hinweis:</h5>
<ul>
<li >beim Buchnamen reicht ein Bruchst&uuml;ck des Namens (ein % am Anfang sucht 
		den Ausdruck an irgendeiner Stelle des Titels)</li>
<li>Keywords (z.B. RDB, ER, OODB,..) und Author m&uuml;ssen exakt eingegeben werden</li>
</ul>
</p><br/>

<form method="post" action="index.jsp" style="display: inline-block">
	<input type="hidden" name="menu" value="buch_suchen" />
	
	<table class="table table-striped">
		<tbody>
    		<tr><td>Name</td><td><input name="name" value="${param.name}" /></td></tr>
		    <tr><td>Keywords</td><td><input name="keywords" value="${param.keywords}" /></td></tr>
			<tr><td>Author</td><td><input name="author" value="${param.author}" /></td>
			</tr>
		</tbody>
	</table>
	<button type="submit" class="btn btn-primary" style="float: right">
					<span class="glyphicon glyphicon-search"></span> Suchen...
				</button>
</form>

<br />  

<c:choose>
	<c:when test="${empty param.name and empty param.author and empty param.keywords}">
		<div class="warning">
		  <p >Bitte geben Sie Suchparameter ein!</p>
	   </div>
	</c:when>
	<c:otherwise>
		<sql:query var="buecher" 
			sql="select titel, Buecher.isbn, Buecher.verlagsname, verlagsort, buch_exemplare.auflage,
				jahr, seiten, preis, count(*) anzahl  
				from Buecher, verlage, Buch_exemplare, Buch_versionen
				where Buecher.verlagsname = Verlage.verlagsname and Buecher.isbn = Buch_Versionen.isbn 
				and Buch_versionen.auflage = buch_exemplare.auflage and Buecher.isbn = Buch_Exemplare.isbn 
				and (lower(titel) like ?)
				and ((? is null) or (? in (select lower(Autor) from Buch_Autor where Buch_Autor.isbn = Buecher.isbn))) 
				and ((? is null) or (? in (select lower(Stichwort) from Buch_Stichwort where Buch_Stichwort.isbn = Buecher.isbn))) 
				group by titel, Buecher.isbn, Buecher.verlagsname, verlagsort, buch_exemplare.auflage, jahr, seiten, preis 
				order by titel" >
			<sql:param value="${fn:toLowerCase(param.name)}%" />
			<sql:param value="${param.author}" />
			<sql:param value="${fn:toLowerCase(param.author)}" />
			<sql:param value="${param.keywords}" />
			<sql:param value="${fn:toLowerCase(param.keywords)}" />
		</sql:query>

		<table class="table table-striped table-responsive manyitems">
			<thead class="thead-light">
				<tr>
					<th scope="col">Buchname</th>
					<th scope="col">Autoren</th>
					<th scope="col">ISBN</th>
					<th scope="col">Verlag</th>
					<th scope="col">Verlagsort</th>
					<th scope="col">vorhandene<br />Exemplare</th>
					<th scope="col">Auflage</th>
					<th scope="col">Erscheinungsjahr</th>
					<th scope="col">Seiten</th>
					<th scope="col">Preis/EUR</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="buch" varStatus="status" begin="0" items="${buecher.rows}">
	 				<sql:query var="autoren" 
						sql="select * from buch_autor where isbn = ?" >
						<sql:param value="${buch.isbn}" />
					</sql:query>
					<c:if test="${status.index mod 2 eq 0}">
					<tr>
					</c:if>
					<c:if test="${status.index mod 2 eq 1}">
					<tr>
					</c:if>
		                <td>${buch.titel}</td>
		                <td>
		                	<c:forEach var="autor" begin="0" items="${autoren.rows}">
		                		${autor.autor}<br />
		                	</c:forEach>
		                </td>
						<td>${buch.isbn}</td>
						<td>${buch.verlagsname}</td>
						<td>${buch.verlagsort}</td>
						<td>${buch.anzahl}</td>
						<td>${buch.auflage}</td>
						<td>${buch.jahr}</td>
						<td>${buch.seiten}</td>
						<td>${buch.preis}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		
	</c:otherwise>
</c:choose>

