<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page language="java" %>
<%@page import="java.io.*" %>

<%
    // 设置请求编码为UTF-8
    request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>商品列表</title>
    <style>
        table {border-collapse: collapse; width: 100%; margin-top: 20px;}
        th, td {border: 1px solid #ddd; padding: 8px; text-align: left;}
        th {background-color: #38a3fb; color: white;}
        tr:nth-child(even) {background-color: #f2f2f2;}
    </style>
</head>
<body>
<table border="1">
    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 1. 加载JDBC驱动
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // 2. 建立数据库连接（请修改为您的实际数据库信息）
            String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true";
            String user = "sa";
            String password = "123456";
            conn = DriverManager.getConnection(url, user, password);

            // 3. 获取用户输入的查询条件
            String ProductID = request.getParameter("ProductID");
            String ProductName = request.getParameter("ProductName");

            // 4. 构建SQL查询语句
            String sql = "SELECT * FROM Products WHERE 1=1";
            if (ProductID != null && !ProductID.trim().isEmpty()) {
                sql += " AND ProductID = ?";
            }
            if (ProductName != null && !ProductName.trim().isEmpty()) {
                sql += " AND ProductName LIKE ?";
            }

            // 5. 创建PreparedStatement对象
            pstmt = conn.prepareStatement(sql);

            // 6. 设置参数
            int paramIndex = 1;
            if (ProductID != null && !ProductID.trim().isEmpty()) {
                pstmt.setInt(paramIndex++, Integer.parseInt(ProductID));
            }
            if (ProductName != null && !ProductName.trim().isEmpty()) {
                // 直接使用参数，不需要手动转换编码
                pstmt.setString(paramIndex, "%" + ProductName + "%");
            }

            // 7. 执行SQL查询
            rs = pstmt.executeQuery();

            // 8. 显示结果
            out.println("<table>");
            out.println("<tr><th>商品ID</th><th>商品名称</th><th>类别</th><th>价格</th><th>库存</th></tr>");

            if (!rs.isBeforeFirst()) {
                // 结果集为空
                out.println("<tr><td colspan='5' style='text-align:center;color:red'>未找到匹配的记录</td></tr>");
            } else {
                while(rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("ProductID") + "</td>");
                    out.println("<td>" + rs.getString("ProductName") + "</td>");
                    out.println("<td>" + (rs.getString("Category") != null ? rs.getString("Category") : "") + "</td>");
                    out.println("<td>" + rs.getDouble("Price") + "</td>");
                    out.println("<td>" + rs.getInt("Stock") + "</td>");
                    out.println("</tr>");
                }
            }

            out.println("</table>");

        } catch(Exception e) {
            out.println("<p style='color:red'>数据库连接错误: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            // 9. 关闭资源
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    %>
</table>
</body>
</html>