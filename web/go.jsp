<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>添加到购物车</title>
    <style>
        /* 全局样式 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f9ff;
            color: #333;
            padding: 20px;
            display: flex;
            justify-content: center;
        }

        /* 容器样式 */
        .form-container {
            max-width: 600px;
            width: 100%;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(50, 100, 200, 0.1);
            overflow: hidden;
        }

        /* 头部样式 */
        .header {
            background-color: #4a90e2;
            color: white;
            padding: 18px 25px;
            text-align: center;
        }

        .header h3 {
            font-size: 22px;
            font-weight: 500;
        }

        /* 内容区域样式 */
        .content {
            padding: 25px;
        }

        /* 消息提示样式 */
        .message {
            margin: 0 0 20px 0;
            padding: 12px;
            border-radius: 5px;
            text-align: center;
            font-size: 16px;
        }

        .success {
            color: #0f5132;
            background-color: #d1e7dd;
            border: 1px solid #badbcc;
        }

        .error {
            color: #842029;
            background-color: #f8d7da;
            border: 1px solid #f5c2c7;
        }

        /* 表格样式 */
        .cart-form {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
        }

        .cart-form th, .cart-form td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .cart-form th {
            background-color: #f0f5ff;
            font-weight: 500;
            color: #333;
        }

        .cart-form input[type="text"], .cart-form input[type="number"] {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 15px;
        }

        .cart-form input[type="text"]:focus, .cart-form input[type="number"]:focus {
            outline: none;
            border-color: #4a90e2;
            box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.2);
        }

        /* 按钮样式 */
        .button-group {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
        }

        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-primary {
            background-color: #4a90e2;
            color: white;
        }

        .btn-primary:hover {
            background-color: #357abd;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(74, 144, 226, 0.3);
        }

        .btn-secondary {
            background-color: #f0f5ff;
            color: #4a90e2;
            border: 1px solid #d1e0f2;
        }

        .btn-secondary:hover {
            background-color: #e1e9f7;
        }

        /* 响应式设计 */
        @media (max-width: 600px) {
            .form-container {
                border-radius: 0;
                box-shadow: none;
            }

            .content {
                padding: 20px;
            }

            .cart-form th, .cart-form td {
                padding: 8px 10px;
                display: block;
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="form-container">
    <div class="header">
        <h3>添加到购物车</h3>
    </div>

    <div class="content">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            String message = "";
            boolean isSuccess = false;

            // 获取从buy.jsp传递的商品ID
            String productIdStr = request.getParameter("productId");
            int productId = -1;

            if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                try {
                    productId = Integer.parseInt(productIdStr);
                } catch (NumberFormatException e) {
                    message = "商品ID无效！";
                }
            } else {
                message = "未获取到商品ID！";
            }

            // 处理表单提交
            if (request.getMethod().equals("POST")) {
                try {
                    // 获取表单参数
                    String cartItemIdStr = request.getParameter("cartItemId");
                    String userIdStr = request.getParameter("userId");
                    String quantityStr = request.getParameter("quantity");

                    // 验证必填参数
                    if (cartItemIdStr == null || cartItemIdStr.trim().isEmpty() ||
                            userIdStr == null || userIdStr.trim().isEmpty() ||
                            quantityStr == null || quantityStr.trim().isEmpty()) {
                        message = "所有字段均为必填项！";
                    } else {
                        // 类型转换
                        int cartItemId = Integer.parseInt(cartItemIdStr);
                        int userId = Integer.parseInt(userIdStr);
                        int quantity = Integer.parseInt(quantityStr);

                        // 验证数量必须大于0
                        if (quantity <= 0) {
                            message = "商品数量必须大于0！";
                        } else {
                            // 加载驱动和创建连接
                            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                            String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true;charset=UTF-8";
                            conn = DriverManager.getConnection(url, "sa", "123456");

                            // 检查cart_item_id是否已存在
                            String checkSql = "SELECT COUNT(*) FROM shopping_cart WHERE cart_item_id = ?";
                            PreparedStatement checkPs = conn.prepareStatement(checkSql);
                            checkPs.setInt(1, cartItemId);
                            ResultSet countRs = checkPs.executeQuery();
                            countRs.next();
                            int count = countRs.getInt(1);
                            countRs.close();
                            checkPs.close();

                            if (count > 0) {
                                message = "购物车项ID已存在，请使用其他ID！";
                            } else {
                                // 插入购物车数据
                                String sql = "INSERT INTO shopping_cart (cart_item_id, UserID, ProductID, quantity, status) " +
                                        "VALUES (?, ?, ?, ?, 'unsettled')";
                                pstmt = conn.prepareStatement(sql);
                                pstmt.setInt(1, cartItemId);
                                pstmt.setInt(2, userId);
                                pstmt.setInt(3, productId);
                                pstmt.setInt(4, quantity);

                                // 执行插入
                                int num = pstmt.executeUpdate();

                                if (num > 0) {
                                    message = "商品已成功添加到购物车！";
                                    isSuccess = true;
                                } else {
                                    message = "添加失败：数据库操作错误";
                                }
                            }
                        }
                    }
                } catch (NumberFormatException e) {
                    message = "所有输入必须是有效的数字！";
                } catch (Exception e) {
                    message = "系统错误：" + e.getMessage();
                    e.printStackTrace();
                } finally {
                    // 关闭资源
                    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
            }
        %>

        <% if (!message.isEmpty()) { %>
        <div class="message <%= isSuccess ? "success" : "error" %>"><%= message %></div>
        <% } %>

        <!-- 添加到购物车表单 -->
        <form action="go.jsp?productId=<%= productId %>" method="post">
            <input type="hidden" name="productId" value="<%= productId %>">

            <table class="cart-form">
                <tbody>
                <tr>
                    <th>购物车项ID</th>
                    <td>
                        <input type="text" id="cartItemId" name="cartItemId" placeholder="请输入购物车项ID" required>
                    </td>
                </tr>
                <tr>
                    <th>用户ID</th>
                    <td>
                        <input type="text" id="userId" name="userId" placeholder="请输入用户ID" required>
                    </td>
                </tr>
                <tr>
                    <th>商品数量</th>
                    <td>
                        <input type="number" id="quantity" name="quantity" placeholder="请输入商品数量" value="1" min="1" required>
                    </td>
                </tr>
                <tr>
                    <th>商品ID</th>
                    <td><%= productId %></td>
                </tr>
                </tbody>
            </table>

            <div class="button-group">
                <input type="submit" value="添加到购物车" class="btn btn-primary">
                <a href="buy.jsp" class="btn btn-secondary">返回商品列表</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>