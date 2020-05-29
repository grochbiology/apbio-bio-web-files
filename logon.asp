<% @language="vbscript" %>
<!--#include virtual="/logon/_private/logon.inc"-->
<%
  ' Was this page posted to?
  If UCase(Request.ServerVariables("HTTP_METHOD")) = "POST" Then
    ' If so, check the username/password that was entered.
    If ComparePassword(Request("UID"),Request("PWD")) Then
      ' If comparison was good, store the user name...
      Session("UID") = Request("UID")
      ' ...and redirect back to the original page.
      Response.Redirect Session("REFERRER")
    End If
  End If
%>
<html>
<head><title>Logon Page</title>
<style>
body  { font-family: arial, helvetica }
table { background-color: #cccccc; font-size: 9pt; padding: 3px }
td    { color: #000000; background-color: #cccccc; border-width: 0px }
th    { color: #ffffff; background-color: #0000cc; border-width: 0px }
</style>
</head>
<body bgcolor="#000000" text="#ffffff">
<h3 align="center">&#xa0;</h3>
<div align="center"><center>
<form action="<%=LOGON_PAGE%>" method="POST">
<table border="2" cellpadding="2" cellspacing="2">
  <tr>
    <th colspan="4" align="left">Enter User Name and Password</th>
  </tr>
  <tr>
    <td>&#xa0;</td>
    <td colspan="2" align="left">Please type your user name and password.</td>
    <td>&#xa0;</td>
  </tr>
  <tr>
    <td>&#xa0;</td>
    <td align="left">Site</td>
    <td align="left"><%=Request.ServerVariables("SERVER_NAME")%> &#xa0;</td>
    <td>&#xa0;</td>
  </tr>
  <tr>
    <td>&#xa0;</td>
    <td align="left">User Name</td>
    <td align="left"><input name="UID" type="text" size="20"></td>
    <td>&#xa0;</td>
  </tr>
  <tr>
    <td>&#xa0;</td>
    <td align="left">Password</td>
    <td align="left"><input name="PWD" type="password" size="20"></td>
    <td>&#xa0;</td>
  </tr>
  <tr>
    <td>&#xa0;</td>
    <td colspan="2" align="center"><input type="submit" value="LOGON"></td>
    <td>&#xa0;</td>
  </tr>
</table>
</form>
</center></div>
</body>
</html>