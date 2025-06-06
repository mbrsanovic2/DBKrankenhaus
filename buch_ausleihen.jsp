<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
 
<sql:setDataSource
  driver="oracle.jdbc.driver.OracleDriver"
  url="jdbc:oracle:thin:@localhost:1521/xepdb1"
  user="user"
  password="password"
/>

<h2>Ausgeliehene B&uuml;cher anzeigen</h2>
  
<p>Bitte w&auml;hlen Sie aus der Drop-Down Liste ihren Namen aus und dr&uuml;cken Sie "Anzeigen".</p>

<form method="post" action="index.jsp">
	<input type="hidden" name="menu" value="buch_ausleihen" />
	
    <select name="name" size="1">
	    <option value="">kein Name ausgew&auml;hlt</option>
	    
		<sql:query var="personen" 
			sql="select (Vorname||' '||Nachname) name from Personen order by name, vorname" >
		</sql:query>

		<c:forEach var="person" begin="0" items="${personen.rows}">
			<option value="${person.name}" <c:if test="${param.name eq person.name}">selected="selected"</c:if>>
            	${person.name}
            </option>
		</c:forEach>
	</select>
    
	<button type="submit" class="btn btn-primary">
		<span class="glyphicon glyphicon-search"></span> Anzeigen
    </button>
</form>
<br />
<br />

<c:if test="${!empty param.name}">
	<sql:query var="buecher" 
		sql="select ausleihe.inventarnr, Buecher.titel, Buecher.verlagsname 
		from ausleihe, Buch_exemplare, Buecher 
		where Buecher.isbn = Buch_Exemplare.isbn and Ausleihe.inventarnr = Buch_Exemplare.inventarnr 
		and ausleihe.inventarnr in (select ausleihe.Inventarnr from ausleihe 
			where ausleihe.panr = (select personen.panr from personen where (Vorname||' '||Nachname) = ?))">
		<sql:param value="${param.name}" />
	</sql:query>

	<c:if test="${buecher.rowCount le 0}">
		<div class="container">Sie haben keine B&uuml;cher entliehen.</div>
	</c:if>
	<c:if test="${buecher.rowCount gt 0}">
	    <table class="table table-striped table-responsive">
	    	<thead class="thead-light">
			    <tr>
			    	<th scope="col">Inventarnr.</th>
			    	<th scope="col">Buchname</th>
			    	<th scope="col">Verlag</th>
			    </tr>
			</thead>
			<tbody>
				<c:forEach var="buch" varStatus="status" begin="0" items="${buecher.rows}">
					<c:if test="${status.index mod 2 eq 0}">
					<tr class="list-row-even">
					</c:if>
					<c:if test="${status.index mod 2 eq 1}">
					<tr>
					</c:if>
			            <td>${buch.inventarnr}</td>
			            <td>${buch.titel}</td>
			            <td>${buch.verlagsname}</td>
		            </tr>
				</c:forEach>
			</tbody>
		</table>
	</c:if>
</c:if>

