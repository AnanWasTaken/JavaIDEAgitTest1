<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>商品更新</title>
</head>
<body>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        // 获取请求参数并处理空值
        String productID = request.getParameter("productID");
        String productName = request.getParameter("productName");
        String price = request.getParameter("price");
        String category = request.getParameter("category");
        String stock = request.getParameter("stock");

        // 只有当存在productID参数时才进行完整检查
        if (productID != null) {
            // 检查必要参数是否为空
            if (productName == null || price == null || category == null || stock == null) {
                request.setAttribute("message", "更新失败：缺少必要参数");
                request.getRequestDispatcher("editgoods.jsp").forward(request, response);
                return;
            }
        } else {
            // 没有productID参数，可能是直接访问页面
            request.setAttribute("message", "商品管理");
            request.getRequestDispatcher("editgoods.jsp").forward(request, response);
            return;
        }

        // 加载驱动和创建连接
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true;charset=UTF-8";
        conn = DriverManager.getConnection(url, "sa", "123456");

        // 创建预编译语句
        String sql = "UPDATE Products SET ProductName=?, Category=?, Price=?, Stock=? WHERE ProductID=?";
        pstmt = conn.prepareStatement(sql);

        // 设置参数
        pstmt.setString(1, productName);
        pstmt.setString(2, category);
        pstmt.setFloat(3, Float.parseFloat(price));  // 字符串转浮点数
        pstmt.setInt(4, Integer.parseInt(stock));     // 字符串转整数
        pstmt.setInt(5, Integer.parseInt(productID));

        // 执行更新
        int num = pstmt.executeUpdate();

        // 处理结果
        if(num > 0) {
            request.setAttribute("message", "更新成功！！！");
        } else {
            request.setAttribute("message", "更新失败：未找到匹配记录");
        }
    } catch(NumberFormatException e) {
        request.setAttribute("message", "更新失败：价格或库存格式不正确");
    } catch(Exception e) {
        request.setAttribute("message", "系统错误：" + e.getMessage());
    } finally {
        // 手动关闭资源（兼容Java 1.6）
        if(pstmt != null) {
            try { pstmt.close(); } catch(Exception e) {/* 忽略 */}
        }
        if(conn != null) {
            try { conn.close(); } catch(Exception e) {/* 忽略 */}
        }
    }
    request.getRequestDispatcher("editgoods.jsp").forward(request, response);
%>
</body>
</html>
