<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
 
<sql:setDataSource var="ds"
  driver="oracle.jdbc.driver.OracleDriver"
  url="jdbc:oracle:thin:@localhost:1521/xepdb1"
  user="system"
  password="password"
/>
<!-- USERDATEN SPÄTER ÄNDERN
user="csdc26bb_03"
  password="urieGoo7la"
-->

<h2>Behandlungen</h2><hr>

<h4>Patient</h4>
  
<p>Behandlungen f&uuml;r Patient Nr. <strong><c:out value="${sessionScope.ptnr}" /></strong></p>

<!-- Zeige Behandlungen für ausgewählten Patient -->
<sql:query var="behandlungen_patient" dataSource="${ds}">
    SELECT * FROM Behandlung
    WHERE (TZeit, BID) IN (
        SELECT TZeit, BID
        FROM Merkt_vor
        WHERE PtNr = ?
    )
    <sql:param value="${sessionScope.ptnr}" />
</sql:query>

<c:if test="${fn:length(behandlungen_patient.rows) == 0}">
    <p>Noch keine Behandlungen zugeordnet.</p>
</c:if>

<ul>
    <c:forEach var="b" items="${behandlungen_patient.rows}">
        <li><c:out value="${b.TZeit}" /> , Raum: <c:out value="${b.RaumCode}" /></li>
    </c:forEach>
</ul>
<br>

<h4>Angebotene Behandlungen</h4>

<p>Aktuell werden folgende Behandlungen angeboten</p>

<!-- Zeige alle angebotene Behandlungen -->
<sql:query var="behandlungen" dataSource="${ds}">
    SELECT bt.BID, bt.Dauer, bt.Kosten, bt.BtrAnz, b.TZeit, o.RaumCode, o.Beschreibung
    FROM Behandlungstyp bt, Behandlung b, Ort o
    WHERE bt.BID = b.BID
        AND b.RaumCode = o.RaumCode
</sql:query>

<table class="table table-striped table-responsive manyitems">
    <thead class="thead-light">
        <tr>
            <th scope="col">BID</th>
            <th scope="col">Raumcode</th>
            <th scope="col">Raumbeschreibung</th>
            <th scope="col">Tageszeit</th>
            <th scope="col">Dauer</th>
            <th scope="col">Kosten</th>
            <th scope="col">Anzahl Betreuer</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="behandlung" varStatus="status" begin="0" items="${behandlungen.rows}">
            <tr>
                <td>${behandlung.BID}</td>
                <td>${behandlung.RaumCode}</td>
                <td>${behandlung.Beschreibung}</td>
                <td>${behandlung.TZeit}</td>
                <td>${behandlung.Dauer} min</td>
                <td>${behandlung.Kosten} EUR</td>
                <td style="text-align: center;">${behandlung.BtrAnz}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>