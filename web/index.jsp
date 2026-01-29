<%-- 
    Document   : Connection
    Created on : 2025-5-17, 9:44:17
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
    <title>商品列表</title>
    <style>
        table {border-collapse: collapse; width: 100%; margin-top: 20px;}
        th, td {border: 1px solid #ddd; padding: 8px; text-align: left;}
        th {background-color: #3395f8; color: white;}
        tr:nth-child(even) {background-color: #f2f2f2;}
    </style>
</head>
<body>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        // 1. 加载JDBC驱动
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        // 2. 建立数据库连接（请修改为您的实际数据库信息）
        String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true";
        String user = "sa";
        String password = "123456";
        conn = DriverManager.getConnection(url, user, password);
        out.print("<h2 style='color:blue'>数据库连接正常!</h2>");
        // 3. 创建Statement对象
        stmt = conn.createStatement();

        // 4. 执行SQL查询
        String sql = "SELECT * FROM Products";
        rs = stmt.executeQuery(sql);

        // 5. 显示结果
        out.println("<table>");
        out.println("<tr><th>商品ID</th><th>商品名称</th><th>类别</th><th>价格</th><th>库存</th></tr>");

        while(rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getInt("ProductID") + "</td>");
            out.println("<td>" + rs.getString("ProductName") + "</td>");
            out.println("<td>" + rs.getString("category") + "</td>");
            out.println("<td>" + rs.getDouble("Price") + "</td>");
            out.println("<td>" + rs.getInt("Stock") + "</td>");
            out.println("</tr>");
        }

        out.println("</table>");

    } catch(Exception e) {
        out.println("<p style='color:red'>数据库连接错误: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        // 6. 关闭资源
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(stmt != null) stmt.close(); } catch(Exception e) {}
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
%>
</body>
</html>

