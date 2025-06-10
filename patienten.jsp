<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<% pageContext.setAttribute("items", new String[]{"one", "two", "three"}); %>

<sql:setDataSource
  driver="oracle.jdbc.driver.OracleDriver"
  url="jdbc:oracle:thin:@localhost:1521/xepdb1"
  user="csdc26bb_03"
  password="urieGoo7la"
/>
<!-- LOKALE USERDATEN
  user="system"
  password="password"
-->

<h2>Patienten</h2>
<hr>
<h4>Zum anlegen eines Patienten Bitte Felder ausf&uuml;llen</h4><br>

<form id="patientForm" method="post" action="patient_speichern.jsp">
  <div class="row">
    <div class="col">
      <label for="vorname">Vorname:</label><br>
      <input type="text" id ="vorname" name="vorname"><br><br>
    </div>
    <div class="col">
      <label for="nachname">Nachname:</label><br>
      <input type="text" id ="nachname" name="nachname"><br><br>
    </div>
    <div class="col">
      <label for="svnr">SVNR:</label><br>
      <input type="text" id ="svnr" name="svnr" required><br><br>
    </div>
  </div>

  <div class="row">
    <div class="col">
      <label for="gbdat">Geburtsdatum:</label><br>
      <input type="date" id ="gbdat" name="gbdat"><br><br>
    </div>
    <div class="col">
      <label for="plz">PLZ:</label><br>
      <input type="text" id ="plz" name="plz"><br><br>
    </div>
    <div class="col">
      <label for="ort">Ort:</label><br>
      <input type="text" id ="ort" name="ort"><br><br>
    </div>
  </div>

  <div class="row">
    <div class="col">
      <label for="strasse">Stra&szlig;e:</label><br>
      <input type="text" id ="strasse" name="strasse"><br><br>
    </div>
    <div class="col">
      <label for="hausNr">HausNr:</label><br>
      <input type="text" id ="haus" name="haus"><br><br>
    </div>
    <div class="col">
      <label for="tel">TelefonNr:</label><br>
      <input type="text" id ="tel" name="tel"><br><br>
    </div>
  </div>

  <button type="submit" class="btn btn-primary">Patient erstellen</button>
</form>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("patientForm");

    form.addEventListener("submit", function (event) {

      const formData = new FormData(form);
      const data = {};

      for (const [key, value] of formData.entries()) {
        data[key] = value;
      }

      console.log("Form Submitted:");
      console.log(data);
    });
  });
</script>