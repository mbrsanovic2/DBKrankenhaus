<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<sql:setDataSource
    var="db"
    driver="oracle.jdbc.driver.OracleDriver"
    url="jdbc:oracle:thin:@localhost:1521/xepdb1"
    user="csdc26bb_03"
    password="urieGoo7la"
/>
<!-- LOKALE USERDATEN
  user="system"
  password="password"
-->

<%
    request.setCharacterEncoding("UTF-8");

    String action = request.getParameter("action");
    String svnr = request.getParameter("svnr");

    if ("logout".equals(action)) {
        session.invalidate();
        response.sendRedirect("index.jsp?menu=login");
        return;
    } else if (svnr != null) {
        pageContext.setAttribute("enteredSvnr", svnr.trim());
    }
%>


<c:if test="${not empty enteredSvnr}">
    <sql:query var="loginCheck" dataSource="${db}">
        SELECT 
            a.ARNR AS arnr, 
            p.NACHNAME AS nachname,
            p.SVNR AS svnr
        FROM 
            PERSON p
            JOIN ANGESTELLTER ag ON p.SVNR = ag.SVNR
            JOIN ARZT a ON ag.ANNR = a.ANNR
        WHERE 
            p.SVNR = ?
        <sql:param value="${enteredSvnr}" />
    </sql:query>

    <c:choose>
        <c:when test="${not empty loginCheck.rows}">
            <c:set var="arzt" value="${loginCheck.rows[0]}" />

            <c:set target="${sessionScope}" property="svnr" value="${arzt.svnr}" />
            <c:set target="${sessionScope}" property="arname" value="${arzt.nachname}" />
            <c:set target="${sessionScope}" property="arnr" value="${arzt.arnr}" />

            <c:redirect url="index.jsp" />

        </c:when>
        <c:otherwise>
            <c:redirect url="index.jsp?menu=login&fehler=1" />
        </c:otherwise>
    </c:choose>
</c:if>


<!-- Kein Arzt in der Session gespeichert: Login anzeigen -->
<c:if test="${empty sessionScope.arname}">
    <h2>Login für Ärzte</h2>
    <hr>
    
    <c:if test="${param.fehler == '1'}">
        <p style="color: red;">
            Ungültige SVNR – bitte erneut versuchen.
        </p>
    </c:if>
    
    <form method="post" action="login.jsp" class="form-inline mt-3">
        <label for="svnr" style="margin-right: 8px;">SVNR:</label>
        <input type="text" id="svnr" name="svnr" class="form-control mr-2" required />
        <button type="submit" class="btn btn-primary" style="margin-left: 8px;">Einloggen</button>
    </form>
</c:if>


<!-- Ein Arzt ist in der Session gespeichert: Logout anzeigen -->
<c:if test="${not empty sessionScope.arname}">
    <h2>Logout</h2>
    <hr>

    <p>Möchten Sie schon gehen Dr. ${sessionScope.arname}?</p>

    <form method="post" action="login.jsp">
        <input type="hidden" name="action" value="logout" />
        <button type="submit" class="btn btn-secondary">Abmelden</button>
    </form>
</c:if>