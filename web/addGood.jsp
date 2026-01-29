<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>添加新商品</title>
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
            font-size: 20px;
            font-weight: 500;
        }

        /* 内容区域样式 */
        .content {
            padding: 25px;
        }

        /* 错误消息样式 */
        .error {
            margin: 0 0 15px 0;
            padding: 10px;
            border-radius: 5px;
            color: #842029;
            background-color: #f8d7da;
            border: 1px solid #f5c2c7;
            text-align: center;
        }

        /* 表单样式 */
        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }

        input[type="text"], textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus, textarea:focus {
            outline: none;
            border-color: #4a90e2;
            box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.2);
        }

        textarea {
            min-height: 80px;
            resize: vertical;
        }

        /* 按钮样式 */
        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 25px;
        }

        .btn {
            padding: 12px 18px;
            border: none;
            border-radius: 5px;
            font-size: 15px;
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

        /* 表单提示样式 */
        .form-hint {
            margin-top: 5px;
            font-size: 13px;
            color: #888;
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
        }
    </style>
</head>
<body>
<div class="form-container">
    <div class="header">
        <h3>添加新商品</h3>
    </div>

    <div class="content">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            String message = "";

            // 处理表单提交
            if (request.getMethod().equals("POST")) {
                try {
                    // 获取表单参数
                    String productIDStr = request.getParameter("productID");
                    String productName = new String(request.getParameter("productName").getBytes("ISO-8859-1"), "UTF-8");
                    String category = new String(request.getParameter("category").getBytes("ISO-8859-1"), "UTF-8");
                    String priceStr = request.getParameter("price");
                    String stockStr = request.getParameter("stock");
                    String categoryIDStr = request.getParameter("categoryID");
                    String merchantIDStr = request.getParameter("merchantID");

                    // 验证必填参数
                    if (productName == null || productName.trim().isEmpty() ||
                            category == null || category.trim().isEmpty() ||
                            priceStr == null || priceStr.trim().isEmpty() ||
                            stockStr == null || stockStr.trim().isEmpty() ||
                            categoryIDStr == null || categoryIDStr.trim().isEmpty() ||
                            merchantIDStr == null || merchantIDStr.trim().isEmpty()) {
                        message = "所有字段均为必填项！";
                    } else {
                        // 类型转换
                        int productID = Integer.parseInt(productIDStr);
                        float price = Float.parseFloat(priceStr);
                        int stock = Integer.parseInt(stockStr);
                        int categoryID = Integer.parseInt(categoryIDStr);
                        int merchantID = Integer.parseInt(merchantIDStr);

                        // 加载驱动和创建连接
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true;charset=UTF-8";
                        conn = DriverManager.getConnection(url, "sa", "123456");

                        // 插入数据的SQL语句
                        String sql = "INSERT INTO Products (ProductID, ProductName, Category, Price, Stock, CategoryID, MerchantID) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?)";
                        pstmt = conn.prepareStatement(sql);

                        // 设置参数
                        pstmt.setInt(1, productID);
                        pstmt.setString(2, productName);
                        pstmt.setString(3, category);
                        pstmt.setFloat(4, price);
                        pstmt.setInt(5, stock);
                        pstmt.setInt(6, categoryID);
                        pstmt.setInt(7, merchantID);

                        // 执行插入
                        int num = pstmt.executeUpdate();

                        if (num > 0) {
                            message = "添加成功！";
                        } else {
                            message = "添加失败：数据库操作错误";
                        }
                    }
                } catch (NumberFormatException e) {
                    message = "编号、价格、库存、分类ID和商家ID必须是有效的数字！";
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

        <div class="error"><%= message %></div>

        <!-- 添加商品表单 -->
        <form action="addGood.jsp" method="post">
            <div class="form-group">
                <label for="productID">商品编号</label>
                <input type="text" id="productID" name="productID" placeholder="请输入商品编号（整数）" required>
                <div class="form-hint">请输入一个唯一的整数编号</div>
            </div>

            <div class="form-group">
                <label for="productName">商品名称</label>
                <input type="text" id="productName" name="productName" placeholder="请输入商品名称" required>
            </div>

            <div class="form-group">
                <label for="category">类别</label>
                <textarea id="category" name="category" placeholder="请输入商品类别" required></textarea>
            </div>

            <div class="form-group">
                <label for="price">价格</label>
                <input type="text" id="price" name="price" placeholder="例如: 1999.00" required>
                <div class="form-hint">请输入数字，支持小数点</div>
            </div>

            <div class="form-group">
                <label for="stock">库存</label>
                <input type="text" id="stock" name="stock" placeholder="请输入库存数量（整数）" required>
            </div>

            <div class="form-group">
                <label for="categoryID">分类ID</label>
                <input type="text" id="categoryID" name="categoryID" placeholder="请输入分类ID（整数）" required>
            </div>

            <div class="form-group">
                <label for="merchantID">商家ID</label>
                <input type="text" id="merchantID" name="merchantID" placeholder="请输入商家ID（整数）" required>
            </div>

            <div class="button-group">
                <input type="submit" value="添加" class="btn btn-primary">
                <a href="editgoods.jsp" class="btn btn-secondary">返回管理页</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
