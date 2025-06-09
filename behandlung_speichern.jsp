<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<sql:setDataSource
    var="ds"
    driver="oracle.jdbc.OracleDriver"
    url="jdbc:oracle:thin:@localhost:1521/xepdb1"
    user="csdc26bb_03"
    password="urieGoo7la"
/>
<!-- LOKALE USERDATEN
  user="system"
  password="password"
-->

<!-- Behandlung in MERKT_VOR eintragen -->
<c:if test="${not empty param.bid && not empty param.tzeit && not empty param.datum}">
    
    <!-- Prüfen, ob diese Behandlung bereits existiert -->
    <sql:query var="exists" dataSource="${ds}">
        SELECT COUNT(*) AS cnt
        FROM Merkt_vor
        WHERE PtNr = ?
          AND ArNr = ?
          AND TZeit = ?
          AND BID = ?
          AND Datum = TO_DATE(?, 'YYYY-MM-DD')
        <sql:param value="${sessionScope.ptnr}" />
        <sql:param value="${sessionScope.arnr}" />
        <sql:param value="${param.tzeit}" />
        <sql:param value="${param.bid}" />
        <sql:param value="${param.datum}" />
    </sql:query>

    <!-- Wenn NICHT vorhanden: Einfügen + Weiterleitung wieder zu Behandlung -->
    <c:if test="${exists.rows[0].cnt == 0}">
        <sql:update dataSource="${ds}">
            INSERT INTO Merkt_vor (PtNr, ArNr, TZeit, BID, Datum)
            VALUES (?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'))
            <sql:param value="${sessionScope.ptnr}" />
            <sql:param value="${sessionScope.arnr}" />
            <sql:param value="${param.tzeit}" />
            <sql:param value="${param.bid}" />
            <sql:param value="${param.datum}" />
        </sql:update>
        
        <%
            session.setAttribute("letzteBehandlung_tzeit", request.getParameter("tzeit"));
            session.setAttribute("letzteBehandlung_datum", request.getParameter("datum"));
            session.setAttribute("letzteBehandlung_ptnr", session.getAttribute("ptnr"));
        %>
        <c:redirect url="index.jsp?menu=behandlungen" />
    </c:if>

    <!-- Wenn schon vorhanden: Fehlermeldung anzeigen -->
    <c:if test="${exists.rows[0].cnt != 0}">
        <c:set
            var="fehler"
            value="Behandlung wurde bereits f&uuml;r dieses Datum zugewiesen.<br>Bitte w&auml;hlen Sie ein anderes Datum oder eine andere Behandlung."
            scope="session"
        />
        <c:set var="vorwahl_bid" value="${param.bid}" scope="session" />
        <c:set var="vorwahl_tzeit" value="${param.tzeit}" scope="session" />
        <c:set var="vorwahl_datum" value="${param.datum}" scope="session" />
        <c:redirect url="index.jsp?menu=behandlungen" />
    </c:if>
</c:if>
