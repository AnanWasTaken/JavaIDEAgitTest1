<%-- 
    Document   : login
    Created on : 2025-5-17, 14:52:19
    Author     : Administrator
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String Account=request.getParameter("Account");
            String Password=request.getParameter("Password");
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");//加载驱动类
           String url="jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true";//设置数据库的Url地址
            //jdbc 主协议 :sqlserver 子协议://127.0.0.1 本地地址 :1433 端口号;DatabaseName=名称
            //                                      自己机器上或服务器上的数据库名称
           Connection conn=DriverManager.getConnection(url, "sa", "123456");
           Statement stmt=conn.createStatement();//创建执行sql语句对象。
           String sql="select * from Users where Account='"+Account+"' and Password='"+Password+"'";
           ResultSet rs= stmt.executeQuery(sql);//执行查询语句，并且返回一个ResultSet对象。
          if( rs.next()){
            session.setAttribute("Account", rs.getString("Account"));
           response.sendRedirect("welcome.jsp");
          
          }else
          {         
           response.sendRedirect("login.html");          
          }
              rs.close();
              stmt.close();       
               conn.close();
            
          %>
    </body>
</html>
