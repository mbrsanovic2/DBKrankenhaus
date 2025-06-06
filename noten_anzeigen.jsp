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

<p> Bitte w&auml;hlen Sie Ihre Matrikelnummer aus:</p>

<form method="post" action="index.jsp">
		<input type="hidden" name="menu" value="noten_ergebnis" />
		
	    Ergebnisse f&uuml;r 
	    <select name="matnr" size="1">
		    <sql:query var="studenten" 
		      sql="select distinct matrikelnummer from prueft order by matrikelnummer" >
		    </sql:query>
		    
		    <c:forEach var="student" begin="0" items="${studenten.rows}">
		    	<option value="${student.matrikelnummer}">${student.matrikelnummer}</option>
		    </c:forEach>
	    </select>
	
			<button type="submit" class="btn btn-primary">
					<span class="glyphicon glyphicon-search"></span> Anzeigen...
			</button>
</form>
