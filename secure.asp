<% @language="vbscript" %>
<!--#include virtual="/logon/_private/logon.inc"-->
<html>
<head><title>Secure Page</title></head>
<body>
<h3>Secure Page</h3>
<p>You are logged on as: 
<%
  If Len(Session("UID")) = 0 Then
    Response.Write "<b>You are not logged on.</b>"
  Else
    Response.Write "<b>" & Session("UID") & "</b>"
  End If
%>
</p>
<p><a href="default.asp">Back to default</a></p>
</body>
</html>