<!doctype html>
<%@ page contentType="text/html" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<% pageContext.setAttribute("items", new String[]{"one", "two", "three"}); %>

<sql:setDataSource
  driver="oracle.jdbc.driver.OracleDriver"
  url="jdbc:oracle:thin:@localhost:1521/xepdb1"
  user="user"
  password="password"
/>

<html>
<head>
<title>Welcome</title>
</head>
<body>
   <h2>Hello World!</h2>
    Here are my tables:

    <sql:query var="tables" 
      sql="select * from tab" >
    </sql:query>

    <table border="1">
    <tr>
    <th>TNAME</th><th>TABTYPE</th><th>CLUSTERID</th>
    </tr>
    <c:forEach var="tabRow" begin="0" items="${tables.rowsByIndex}">
        <tr>
        <td>${tabRow[0]}</td><td>${tabRow[1]}</td><td>${tabRow[2]}</td>
        </tr>
    </c:forEach>
    </table>
   
</body>
</html>

