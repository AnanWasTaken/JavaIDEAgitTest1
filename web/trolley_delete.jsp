<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>购物车管理</title>
    <style>
        /* 全局样式 */
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .header {
            margin-bottom: 20px;
            text-align: center;
        }

        .header h3 {
            color: #333;
            font-size: 24px;
            margin-bottom: 10px;
        }

        /* 表单样式 */
        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            transition: border-color 0.2s;
        }

        input[type="text"]:focus {
            border-color: #007bff;
            outline: none;
        }

        button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.2s;
        }

        button:hover {
            background-color: #0069d9;
        }

        /* 删除按钮样式 */
        .btn-delete {
            background-color: #dc3545;
        }

        .btn-delete:hover {
            background-color: #c82333;
        }

        /* 消息提示样式 */
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
            text-align: center;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        /* 表格样式 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
            font-weight: 600;
            color: #333;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        /* 返回按钮样式 */
        .back-btn {
            display: inline-block;
            margin-bottom: 20px;
            color: #007bff;
            text-decoration: none;
            font-size: 15px;
        }

        .back-btn:hover {
            text-decoration: underline;
        }

        /* 商品信息样式 */
        .product-info {
            display: flex;
            gap: 15px;
        }

        .product-image {
            width: 60px;
            height: 60px;
            background-color: #f0f0f0;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }

        .product-details {
            flex: 1;
        }

        .product-name {
            font-weight: 500;
            margin-bottom: 5px;
        }

        .product-price {
            color: #e63946;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="my.jsp" class="back-btn">返回</a>

    <div class="header">
        <h3>我的购物车</h3>
    </div>

    <%
        // 获取用户ID参数
        String userID = request.getParameter("userID");
        // 获取操作类型（delete）和购物车项ID
        String action = request.getParameter("action");
        String cartItemId = request.getParameter("cartItemId");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<CartItem> cartItems = new ArrayList<>();
        String message = null;

        // 如果用户ID不为空，执行查询
        if (userID != null && !userID.trim().isEmpty()) {
            try {
                // 处理删除操作
                if ("delete".equals(action) && cartItemId != null && !cartItemId.trim().isEmpty()) {
                    // 加载数据库驱动并建立连接
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true";
                    conn = DriverManager.getConnection(url, "sa", "123456");

                    // 执行删除操作
                    String deleteSql = "DELETE FROM shopping_cart WHERE cart_item_id = ? AND UserID = ?";
                    ps = conn.prepareStatement(deleteSql);
                    ps.setInt(1, Integer.parseInt(cartItemId));
                    ps.setInt(2, Integer.parseInt(userID));

                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        message = "商品已成功从购物车中删除！";
                    } else {
                        message = "删除失败，可能是购物车项不存在或您没有权限删除。";
                    }

                    // 关闭资源
                    try { if (ps != null) ps.close(); } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }

                // 重新连接数据库查询购物车信息
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true";
                conn = DriverManager.getConnection(url, "sa", "123456");

                // 查询购物车信息
                String sql = "SELECT ci.cart_item_id, ci.UserID, ci.ProductID, ci.quantity, ci.status, p.ProductName, p.Price "
                        + "FROM shopping_cart ci "
                        + "JOIN Products p ON ci.ProductID = p.ProductID "
                        + "WHERE ci.UserID = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(userID));
                rs = ps.executeQuery();

                // 处理查询结果
                while (rs.next()) {
                    CartItem cartItem = new CartItem();
                    cartItem.setCartItemId(rs.getInt("cart_item_id"));
                    cartItem.setUserId(rs.getInt("UserID"));
                    cartItem.setProductId(rs.getInt("ProductID"));
                    cartItem.setQuantity(rs.getInt("quantity"));
                    cartItem.setStatus(rs.getString("status"));
                    cartItem.setProductName(rs.getString("ProductName"));
                    cartItem.setProductPrice(rs.getDouble("Price"));
                    cartItems.add(cartItem);
                }

                if (cartItems.isEmpty() && message == null) {
                    message = "该用户的购物车为空！";
                }
            } catch (NumberFormatException e) {
                message = "UserID 或 CartItemID 必须是有效的数字！";
            } catch (Exception e) {
                message = "系统错误：" + e.getMessage();
                e.printStackTrace();
            } finally {
                // 关闭资源
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }
    %>

    <!-- 用户ID输入表单 -->
    <form method="get" action="trolley_delete.jsp">
        <div class="form-group">
            <label for="userID">请输入用户ID：</label>
            <input type="text" id="userID" name="userID" value="<%= userID != null ? userID : "" %>" required>
            <button type="submit">查询购物车</button>
        </div>
    </form>

    <!-- 显示消息 -->
    <% if (message != null) { %>
    <div class="message <%= message.contains("成功") ? "success" : "error" %>">
        <%= message %>
    </div>
    <% } %>

    <!-- 显示购物车信息 -->
    <% if (userID != null && !userID.trim().isEmpty() && !cartItems.isEmpty()) { %>
    <h4>购物车列表</h4>
    <table>
        <thead>
        <tr>
            <th>购物车项ID</th>
            <th>商品信息</th>
            <th>数量</th>
            <th>单价</th>
            <th>小计</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <% double totalAmount = 0; %>
        <% for (CartItem item : cartItems) { %>
        <% double subtotal = item.getQuantity() * item.getProductPrice(); %>
        <% totalAmount += subtotal; %>
        <tr>
            <td><%= item.getCartItemId() %></td>
            <td>
                <div class="product-info">
                    <div class="product-image">
                        <%= item.getProductId() %>
                    </div>
                    <div class="product-details">
                        <div class="product-name"><%= item.getProductName() %></div>
                        <div class="product-id">商品ID: <%= item.getProductId() %></div>
                    </div>
                </div>
            </td>
            <td><%= item.getQuantity() %></td>
            <td>¥<%= String.format("%.2f", item.getProductPrice()) %></td>
            <td>¥<%= String.format("%.2f", subtotal) %></td>
            <td><%= item.getStatus() %></td>
            <td>
                <form method="get" action="trolley_delete.jsp" onsubmit="return confirm('确定要删除该商品吗？')">
                    <input type="hidden" name="userID" value="<%= userID %>">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                    <button type="submit" class="btn-delete">删除</button>
                </form>
            </td>
        </tr>
        <% } %>
        <tr>
            <td colspan="6" style="text-align: right; font-weight: bold;">总计：</td>
            <td style="font-weight: bold; color: #e63946;">¥<%= String.format("%.2f", totalAmount) %></td>
        </tr>
        </tbody>
    </table>
    <% } %>
</div>
</body>
</html>

<%-- 购物车项类定义 --%>
<%!
    class CartItem {
        private int cartItemId;
        private int userId;
        private int productId;
        private int quantity;
        private String status;
        private String productName;
        private double productPrice;

        // Getters and Setters
        public int getCartItemId() { return cartItemId; }
        public void setCartItemId(int cartItemId) { this.cartItemId = cartItemId; }

        public int getUserId() { return userId; }
        public void setUserId(int userId) { this.userId = userId; }

        public int getProductId() { return productId; }
        public void setProductId(int productId) { this.productId = productId; }

        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }

        public double getProductPrice() { return productPrice; }
        public void setProductPrice(double productPrice) { this.productPrice = productPrice; }
    }
%>
