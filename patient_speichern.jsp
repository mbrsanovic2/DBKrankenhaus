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

<body>
    <%
        String svnr = request.getParameter("svnr");
        String vorname = request.getParameter("vorname");
        String nachname = request.getParameter("nachname");
        String plz = request.getParameter("plz");
        String ort = request.getParameter("ort");
        String strasse = request.getParameter("strasse");
        String haus = request.getParameter("haus");
        String gbdat = request.getParameter("gbdat");
        String tel = request.getParameter("tel");
    %>
    <ul>
        <li>SVNR: <%= svnr %></li>
        <li>Vorname: <%= vorname %></li>
        <li>Nachname: <%= nachname %></li>
        <li>PLZ: <%= plz %></li>
        <li>Ort: <%= ort %></li>
        <li>Straße: <%= strasse %></li>
        <li>HausNr: <%= haus %></li>
        <li>Geburtsdatum: <%= gbdat %></li>
        <li>Telefon: <%= tel %></li>
    </ul>
    <sql:update var="insertPatient" dataSource="${ds}">
        insert into PERSON (SVNR, VORNAME, NACHNAME, PLZ, ORT, STRASSE, HAUSNR, GBDAT, TELNR)
        values (?, ?, ?, ?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?)
        <sql:param value="${param.svnr}" />
        <sql:param value="${param.vorname}" />
        <sql:param value="${param.nachname}" />
        <sql:param value="${param.plz}" />
        <sql:param value="${param.ort}" />
        <sql:param value="${param.strasse}" />
        <sql:param value="${param.haus}" />
        <sql:param value="${param.gbdat}" />
        <sql:param value="${param.tel}" />
    </sql:update>
</body>