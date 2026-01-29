<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Delete Product</title>
</head>
<body>
<%
    String productID = request.getParameter("productID");
    Connection conn = null;
    CallableStatement cs = null;
    boolean deleteSuccess = false;

    if (productID == null || productID.trim().isEmpty()) {
        request.setAttribute("message", "ProductID 不能为空！");
        request.getRequestDispatcher("editgoods.jsp").forward(request, response);
        return;
    }

    try {
        // 加载 JDBC 驱动
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        // 建立数据库连接
        String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true";
        conn = DriverManager.getConnection(url, "sa", "123456");

        // 执行 SQL 删除语句 - 调用存储过程
        String sql = "{call DeleteProductsById(?)}";
        cs = conn.prepareCall(sql);
        cs.setInt(1, Integer.parseInt(productID));

        // 执行存储过程
        int rowsAffected = cs.executeUpdate();  // 使用executeUpdate获取受影响的行数

        // 根据受影响的行数判断删除是否成功
        deleteSuccess = rowsAffected > 0;

        // 根据删除结果跳转
        if (deleteSuccess) {
            request.setAttribute("message", "删除成功！");
        } else {
            request.setAttribute("message", "删除失败！未找到指定的 ProductID。");
        }
        request.getRequestDispatcher("editgoods.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("message", "错误： " + e.getMessage());
        request.getRequestDispatcher("editgoods.jsp").forward(request, response);
    } finally {
        // 关闭资源
        try { if (cs != null) cs.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
</body>
</html>