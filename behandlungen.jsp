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

<!-- Arzt vorerst manuell gesetzt - kommt dann von index // tbd anpassen auf svnr statt arnr -->
<%
	session.setAttribute("arnr", 201);
%>

<h2>Behandlungen</h2><hr>

<!-- Zeige Behandlungen für ausgewählten Patient -->
<h4>Patient</h4>

<c:if test="${sessionScope.ptnr == null}">
    <p>Bitte w&auml;hlen Sie auf der Startseite einen Patienten aus.</p>
</c:if>

<c:if test="${sessionScope.ptnr != null}">
    <sql:query var="patient" dataSource="${ds}">
        SELECT per.Vorname, per.Nachname
        FROM Person per
        JOIN Patient pat ON pat.SVNr = per.SVNr
        WHERE pat.PtNr = ?
        <sql:param value="${sessionScope.ptnr}" />
    </sql:query>

    <p>Behandlungen f&uuml;r 
        <strong>
            <c:out value="${patient.rows[0].Nachname}" /> 
            <c:out value="${patient.rows[0].Vorname}" />
        </strong> 
        (Patient Nr. <c:out value="${sessionScope.ptnr}" />)
    </p>

    <sql:query var="behandlungen_patient" dataSource="${ds}">
        SELECT 
            beh.*,
            TO_CHAR(mvo.Datum, 'DD.MM.YYYY') AS DatumFormat,
            per.Vorname AS ArztVorname,
            per.Nachname AS ArztNachname,
            ort.Beschreibung
        FROM Merkt_vor mvo
        JOIN Behandlung beh ON beh.BID = mvo.BID AND beh.TZeit = mvo.TZeit
        JOIN Arzt arz ON arz.ArNr = mvo.ArNr
        JOIN Angestellter ang ON ang.AnNr = arz.AnNr
        JOIN Person per ON per.SVNr = ang.SVNr
        JOIN ORT ort ON ort.RaumCode = beh.RaumCode
        WHERE mvo.PtNr = ?
        ORDER BY mvo.Datum ASC, mvo.TZeit ASC
        <sql:param value="${sessionScope.ptnr}" />
    </sql:query>

    <c:if test="${fn:length(behandlungen_patient.rows) == 0}">
        <p>Noch keine Behandlungen zugeordnet.</p>
    </c:if>

    <c:if test="${fn:length(behandlungen_patient.rows) != 0}">
         <table class="table table-bordered table-striped table-hover table-sm">
        <thead class="thead-light">
            <tr>
                <th>Datum</th>
                <th>Uhrzeit</th>
                <th>Behandlung</th>
                <th>Raum</th>
                <th>Zust&auml;ndiger Arzt</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="b" items="${behandlungen_patient.rows}">
                <tr>
                    <td><c:out value="${b.DatumFormat}" /></td>
                    <td><c:out value="${b.TZeit}" /></td>
                    <td style="text-align: center;"><c:out value="${b.BID}" /></td>
                    <td><c:out value="${b.RaumCode}" /> <c:out value="${b.Beschreibung}" /></td>
                    <td>Dr. <c:out value="${b.ArztNachname}" /> <c:out value="${b.ArztVorname}" /></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    </c:if>

    <button type="button" class="btn btn-primary" onclick="zeigeBehandlungsFormular()">Neue Behandlung zuweisen</button>
</c:if>


<!-- Zeige alle angebotene Behandlungen für Zuweisung Patient bzw. Übersicht -->
<sql:query var="behandlungen" dataSource="${ds}">
    SELECT
        bht.*,
        beh.TZeit,
        ort.*
    FROM Behandlungstyp bht
    JOIN Behandlung beh ON beh.BID = bht.BID
    JOIN Ort ort ON ort.RaumCode = beh.RaumCode
    WHERE bht.BID = beh.BID
        AND beh.RaumCode = ort.RaumCode
</sql:query>


<!-- Verstecktes Formular, wird onClick "Neue Behandlung zuweisen" eingeblendet oder bei Fehler (Behandlung vorhanden) -->
<script>
    function zeigeBehandlungsFormular() {
        document.getElementById("behandlungsForm").style.display = "block";
    }
</script>

<%
    boolean fehlerVorhanden = session.getAttribute("fehler") != null;
%>

<div id="behandlungsForm" style="display: <%= fehlerVorhanden ? "block" : "none" %>; margin-top: 1rem;">
    <form method="post" action="behandlung_speichern.jsp">
        
        <c:set var="auswahl" value="${sessionScope.vorwahl_bid}|${sessionScope.vorwahl_tzeit}" />

        <div class="form-group">
            <label for="behandlung">Bitte w&auml;hlen Sie eine Behandlung:</label>
            <select class="form-control" id="behandlung" required>
                <option value="">-- Bitte w&auml;hlen --</option>

                <c:forEach var="b" items="${behandlungen.rows}">
                    <c:set var="wert" value="${b.BID}|${b.TZeit}" />
                    <option value="${wert}"
                            data-bid="${b.BID}"
                            data-tzeit="${b.TZeit}"
                            <c:if test="${wert == auswahl}">selected</c:if>>
                        ${b.Beschreibung} - ${b.TZeit}, Raum ${b.RaumCode}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="datum">Datum:</label>
            <input type="date" class="form-control" name="datum" value="${sessionScope.vorwahl_datum}" required>
        </div>

        <c:if test="${not empty sessionScope.fehler}">
            <p style="color: red;">${sessionScope.fehler}</p>
            <c:remove var="fehler" scope="session" />
            <c:remove var="vorwahl_bid" scope="session" />
            <c:remove var="vorwahl_tzeit" scope="session" />
            <c:remove var="vorwahl_datum" scope="session" />
        </c:if>

        <input type="hidden" name="bid" id="bid">
        <input type="hidden" name="tzeit" id="tzeit">

        <button type="submit" class="btn btn-success">Zuweisen</button>
    </form>
</div>

<!-- JavaScript zum Zerlegen von BID und TZEIT -->
<script>
    function setBehandlungValues() {
        const select = document.getElementById("behandlung");
        const selected = select.options[select.selectedIndex];
        document.getElementById("bid").value = selected.dataset.bid;
        document.getElementById("tzeit").value = selected.dataset.tzeit;
    }

    document.addEventListener("DOMContentLoaded", setBehandlungValues);
    document.getElementById("behandlung").addEventListener("change", setBehandlungValues);
</script>


<br><br><br>


<!-- Zeige alle angebotene Behandlungen -->
<h4>Angebotene Behandlungen</h4>
<p>Aktuell werden folgende Behandlungen angeboten</p>

<table class="table table-bordered table-striped table-hover table-sm">
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