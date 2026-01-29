<%@page import="java.sql.*"%>
<%@page import="com.cn.Products"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>编辑商品信息</title>
    </head>
    <body>
        <%
            String ProductID = request.getParameter("productID");
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            Products good = null;

            try {
                if (ProductID == null || ProductID.trim().isEmpty()) {
                    request.setAttribute("message", "ProductID 不能为空！");
                    request.getRequestDispatcher("editgoods.jsp").forward(request, response);
                    return;
                }

                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true";
                conn = DriverManager.getConnection(url, "sa", "123456");

                // 修改1：使用正确的字段名和表名
                String sql = "SELECT ProductID, ProductName, Category, Price, Stock, CategoryID, MerchantID "
                           + "FROM Products "
                           + "WHERE ProductID=?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(ProductID));
                rs = ps.executeQuery();

                if (rs.next()) {
                    good = new Products();
                    // 修改2：使用正确的字段映射
                    good.setProductID(rs.getInt("ProductID"));          // 对应ProductID
                    good.setProductName(rs.getString("ProductName")); // 新增方法
                    good.setCategory(rs.getString("Category")); // 新增方法
                    good.setPrice(rs.getFloat("Price"));
                    good.setStock(rs.getInt("Stock"));
                    good.setCategoryID(rs.getInt("CategoryID"));    // 新增方法
                    good.setMerchantID(rs.getInt("MerchantID"));    // 新增方法
                    
                    request.setAttribute("good", good);
                    request.getRequestDispatcher("editgoods.jsp").forward(request, response);
                } else {
                    request.setAttribute("message", "找不到该商品信息！");
                    request.getRequestDispatcher("editgoods.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("message", "ProductID 必须是有效的数字！");
                request.getRequestDispatcher("editgoods.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("message", "系统错误：" + e.getMessage());
                request.getRequestDispatcher("editgoods.jsp").forward(request, response);
            } finally {
                // 关闭资源
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
    </body>
</html>