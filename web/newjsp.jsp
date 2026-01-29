<%-- 
    Document   : newjsp
    Created on : 2025-5-17, 15:05:19
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
      欢迎：  <%=session.getAttribute("Account")%> ${Account}
        <%=session.getAttribute("")%>
                
    </body>
</html>
