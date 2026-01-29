<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>商品添加</title>
    </head>
    <body>
        <%
        request.setCharacterEncoding("utf-8");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            // 修正参数名匹配数据库字段
            String productID = request.getParameter("ProductID");
            String productName = request.getParameter("ProductName");
            String price = request.getParameter("Price");
            String category = request.getParameter("Category");
            String stock = request.getParameter("Stock");
            String categoryID = request.getParameter("CategoryID");
            String merchantID = request.getParameter("MerchantID");
            
            // 加载驱动和创建连接
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true";
            conn = DriverManager.getConnection(url, "sa", "123456");
            
            // 修正SQL语句匹配数据库表结构
            String sql = "INSERT INTO Products(ProductName, DCategory, Price, Stock,CategoryID,MerchantID) VALUES(?, ?, ?, ?, ?, ?)";
          
            pstmt = conn.prepareStatement(sql);
            
            // 参数绑定
            pstmt.setString(1, productName);
            pstmt.setString(2, category);
            pstmt.setFloat(3, Float.parseFloat(price));  // 转换为浮点数
            pstmt.setInt(4, Integer.parseInt(stock));    // 转换为整数
            pstmt.setInt(5, Integer.parseInt(categoryID));
            pstmt.setInt(6, Integer.parseInt(merchantID));
            
            int num = pstmt.executeUpdate();
            
            if(num > 0) {
                request.setAttribute("message", "添加成功！！！");
            } else {
                request.setAttribute("message", "添加失败！！！");
            }
        } catch(NumberFormatException e) {
            request.setAttribute("message", "数值格式错误: " + e.getMessage());
        } catch(Exception e) {
            request.setAttribute("message", "系统错误: " + e.getMessage());
        } finally {
            // 安全关闭资源
            if(pstmt != null) {
                try { pstmt.close(); } catch(SQLException e) {}
            }
            if(conn != null) {
                try { conn.close(); } catch(SQLException e) {}
            }
        }
        request.getRequestDispatcher("insertfont.jsp").forward(request, response);
        %>
    </body>
</html>