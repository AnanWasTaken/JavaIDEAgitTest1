<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>订单查询</title>
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

        /* 订单详情样式 */
        .order-details {
            margin-top: 10px;
            padding: 10px;
            background-color: #f9f9f9;
            border-radius: 4px;
        }

        .item-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            padding: 5px 0;
            border-bottom: 1px solid #eee;
        }

        .item-row:last-child {
            border-bottom: none;
        }

        .item-name {
            font-weight: 500;
        }

        .item-price {
            color: #e63946;
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
    </style>
</head>
<body>
<div class="container">
    <a href="my.jsp" class="back-btn">返回</a>

    <div class="header">
        <h3>订单查询</h3>
    </div>

    <%
        // 获取用户ID参数
        String userID = request.getParameter("userID");
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();
        String message = null;

        // 如果用户ID不为空，执行查询
        if (userID != null && !userID.trim().isEmpty()) {
            try {
                // 加载数据库驱动并建立连接
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true";
                conn = DriverManager.getConnection(url, "sa", "123456");

                // 查询订单信息
                String sql = "SELECT o.order_id, o.UserID, o.total_amount, o.status, o.address_id, o.order_time "
                        + "FROM order1 o "
                        + "WHERE o.UserID = ? "
                        + "ORDER BY o.order_time DESC";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(userID));
                rs = ps.executeQuery();

                // 处理查询结果
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setUserId(rs.getInt("UserID"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setAddressId(rs.getInt("address_id"));
                    order.setOrderTime(rs.getTimestamp("order_time"));

                    // 查询订单商品明细
                    String itemSql = "SELECT oi.ProductID, oi.quantity, oi.unit_price, oi.ProductName "
                            + "FROM order_item oi "
                            + "WHERE oi.order_id = ?";
                    PreparedStatement itemPs = conn.prepareStatement(itemSql);
                    itemPs.setInt(1, order.getOrderId());
                    ResultSet itemRs = itemPs.executeQuery();

                    List<OrderItem> items = new ArrayList<>();
                    while (itemRs.next()) {
                        OrderItem item = new OrderItem();
                        item.setProductId(itemRs.getInt("ProductID"));
                        item.setProductName(itemRs.getString("ProductName"));
                        item.setQuantity(itemRs.getInt("quantity"));
                        item.setUnitPrice(itemRs.getDouble("unit_price"));
                        items.add(item);
                    }

                    order.setItems(items);
                    orders.add(order);

                    // 关闭订单商品明细查询资源
                    try { if (itemRs != null) itemRs.close(); } catch (Exception e) {}
                    try { if (itemPs != null) itemPs.close(); } catch (Exception e) {}
                }

                if (orders.isEmpty()) {
                    message = "未找到该用户的订单信息！";
                }
            } catch (NumberFormatException e) {
                message = "UserID 必须是有效的数字！";
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
    <form method="get" action="order.jsp">
        <div class="form-group">
            <label for="userID">请输入用户ID：</label>
            <input type="text" id="userID" name="userID" value="<%= userID != null ? userID : "" %>" required>
            <button type="submit">查询订单</button>
        </div>
    </form>

    <!-- 显示错误消息 -->
    <% if (message != null) { %>
    <div class="message <%= message.contains("未找到") || message.contains("必须是") ? "error" : "success" %>">
        <%= message %>
    </div>
    <% } %>

    <!-- 显示订单信息 -->
    <% if (userID != null && !userID.trim().isEmpty() && !orders.isEmpty()) { %>
    <h4>订单列表</h4>
    <table>
        <thead>
        <tr>
            <th>订单ID</th>
            <th>下单时间</th>
            <th>总价</th>
            <th>状态</th>
            <th>商品明细</th>
        </tr>
        </thead>
        <tbody>
        <% for (Order order : orders) { %>
        <tr>
            <td><%= order.getOrderId() %></td>
            <td><%= order.getOrderTime() %></td>
            <td>¥<%= String.format("%.2f", order.getTotalAmount()) %></td>
            <td><%= order.getStatus() %></td>
            <td>
                <div class="order-details">
                    <h5>商品列表</h5>
                    <% if (order.getItems() != null && !order.getItems().isEmpty()) { %>
                    <% for (OrderItem item : order.getItems()) { %>
                    <div class="item-row">
                        <span class="item-name"><%= item.getProductName() %></span>
                        <span>¥<%= String.format("%.2f", item.getUnitPrice()) %> × <%= item.getQuantity() %></span>
                        <span class="item-price">¥<%= String.format("%.2f", item.getUnitPrice() * item.getQuantity()) %></span>
                    </div>
                    <% } %>
                    <% } else { %>
                    <div class="error-message">无法获取商品明细信息</div>
                    <% } %>
                    <div style="margin-top: 10px; font-weight: bold;">
                        订单总额: ¥<%= String.format("%.2f", order.getTotalAmount()) %>
                    </div>
                </div>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>
</body>
</html>

<%-- Order类定义 --%>
<%!
    class Order {
        private int orderId;
        private int userId;
        private double totalAmount;
        private String status;
        private int addressId;
        private Timestamp orderTime;
        private List<OrderItem> items;

        // Getters and Setters
        public int getOrderId() { return orderId; }
        public void setOrderId(int orderId) { this.orderId = orderId; }

        public int getUserId() { return userId; }
        public void setUserId(int userId) { this.userId = userId; }

        public double getTotalAmount() { return totalAmount; }
        public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public int getAddressId() { return addressId; }
        public void setAddressId(int addressId) { this.addressId = addressId; }

        public Timestamp getOrderTime() { return orderTime; }
        public void setOrderTime(Timestamp orderTime) { this.orderTime = orderTime; }

        public List<OrderItem> getItems() { return items; }
        public void setItems(List<OrderItem> items) { this.items = items; }
    }

    class OrderItem {
        private int productId;
        private String productName;
        private int quantity;
        private double unitPrice;

        // Getters and Setters
        public int getProductId() { return productId; }
        public void setProductId(int productId) { this.productId = productId; }

        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }

        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }

        public double getUnitPrice() { return unitPrice; }
        public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }
    }
%>