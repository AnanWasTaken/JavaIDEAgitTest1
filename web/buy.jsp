<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>商品购买</title>
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
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        /* 容器样式 */
        .container {
            max-width: 1000px;
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
            padding: 25px 30px;
        }

        .header h1 {
            font-size: 24px;
            margin-bottom: 5px;
        }

        .header p {
            font-size: 14px;
            opacity: 0.9;
        }

        /* 内容区域样式 */
        .content {
            padding: 30px;
        }

        /* 返回按钮样式 */
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            color: #4a90e2;
            text-decoration: none;
            font-weight: 500;
        }

        .back-btn:hover {
            color: #357abd;
        }

        /* 搜索表单样式 */
        .search-form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 30px;
            justify-content: center;
        }

        .form-group {
            flex: 1;
            min-width: 250px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }

        input[type="text"], select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus, select:focus {
            outline: none;
            border-color: #4a90e2;
            box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.2);
        }

        button, .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-search {
            background-color: #4a90e2;
            color: white;
        }

        .btn-search:hover {
            background-color: #357abd;
        }

        .btn-add {
            background-color: #00b42a;
            color: white;
        }

        .btn-add:hover {
            background-color: #009e25;
        }

        .btn-cancel {
            background-color: #f0f5ff;
            color: #4a90e2;
            border: 1px solid #d1e0f2;
        }

        .btn-cancel:hover {
            background-color: #e1e9f7;
        }

        /* 商品列表样式 */
        .product-list {
            margin-top: 20px;
        }

        .product-card {
            display: flex;
            padding: 20px;
            border-bottom: 1px solid #e9f0f9;
            align-items: center;
            transition: background-color 0.2s;
        }

        .product-card:hover {
            background-color: #f9fcff;
        }

        .product-image {
            width: 80px;
            height: 80px;
            background-color: #f0f0f0;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            margin-right: 20px;
        }

        .product-details {
            flex: 1;
        }

        .product-name {
            font-weight: 600;
            font-size: 18px;
            margin-bottom: 5px;
        }

        .product-info {
            display: flex;
            gap: 15px;
            margin-bottom: 10px;
            color: #666;
        }

        .product-price {
            color: #e63946;
            font-weight: bold;
            font-size: 20px;
        }

        /* 空状态样式 */
        .empty-state {
            text-align: center;
            padding: 30px;
            color: #999;
        }

        .empty-state i {
            font-size: 40px;
            margin-bottom: 15px;
            display: block;
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

        /* 响应式设计 */
        @media (max-width: 768px) {
            .search-form {
                flex-direction: column;
            }

            .form-group {
                min-width: 100%;
            }

            .product-card {
                flex-direction: column;
                text-align: center;
            }

            .product-image {
                margin-right: 0;
                margin-bottom: 15px;
            }

            .product-info {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>商品购买</h1>
        <p>搜索并购买您喜欢的商品</p>
    </div>

    <div class="content">
        <!-- 返回个人中心按钮 -->
        <a href="my.jsp" class="back-btn">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-left-circle" viewBox="0 0 16 16">
                <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                <path d="M8.354 11.354a.5.5 0 0 0 0-.708L5.707 8l2.647-2.646a.5.5 0 1 0-.708-.708l-3 3a.5.5 0 0 0 0 .708l3 3a.5.5 0 0 0 .708 0z"/>
                <path d="M11.5 8a.5.5 0 0 0-.5-.5H6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 .5-.5z"/>
            </svg>
            返回个人中心
        </a>

        <%
            // 处理从go.jsp返回的消息
            String message = request.getParameter("message");
            String status = request.getParameter("status");

            if (message != null && !message.isEmpty()) {
        %>
        <div class="message <%= "success".equals(status) ? "success" : "error" %>"><%= message %></div>
        <%
            }
        %>

        <!-- 搜索表单 -->
        <form id="searchForm" method="post" action="buy.jsp">
            <div class="search-form">
                <div class="form-group">
                    <label for="searchType">搜索类型</label>
                    <select id="searchType" name="searchType">
                        <option value="productID" <%= "productID".equals(request.getParameter("searchType")) ? "selected" : "" %>>按商品ID搜索</option>
                        <option value="productName" <%= "productName".equals(request.getParameter("searchType")) ? "selected" : "" %>>按商品名称搜索</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="searchValue">搜索值</label>
                    <input type="text" id="searchValue" name="searchValue" placeholder="输入商品ID或名称" value="<%= request.getParameter("searchValue") != null ? request.getParameter("searchValue") : "" %>">
                </div>
                <div class="form-group" style="display: flex; align-items: flex-end;">
                    <button type="submit" class="btn btn-search">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
                            <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                        </svg>
                        搜索
                    </button>
                </div>
            </div>
        </form>

        <!-- 商品列表 -->
        <div class="product-list" id="productList">
            <%
                // 处理搜索逻辑
                String searchType = request.getParameter("searchType");
                String searchValue = request.getParameter("searchValue");
                List<Product> products = new ArrayList<>();

                if (searchType != null && searchValue != null && !searchValue.trim().isEmpty()) {
                    try {
                        // 设置字符编码
                        request.setCharacterEncoding("UTF-8");

                        // 加载驱动和创建连接
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test2;Encrypt=true;trustServerCertificate=true;charset=UTF-8";
                        Connection conn = DriverManager.getConnection(url, "sa", "123456");

                        String sql;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        if ("productID".equals(searchType)) {
                            sql = "SELECT p.ProductID, p.ProductName, p.Category, p.Price, p.Stock, p.MerchantID, m.merchant_name " +
                                    "FROM Products p LEFT JOIN Merchants m ON p.MerchantID = m.MerchantID " +
                                    "WHERE p.ProductID = ?";
                            ps = conn.prepareStatement(sql);
                            ps.setInt(1, Integer.parseInt(searchValue));
                        } else {
                            sql = "SELECT p.ProductID, p.ProductName, p.Category, p.Price, p.Stock, p.MerchantID, m.merchant_name " +
                                    "FROM Products p LEFT JOIN Merchants m ON p.MerchantID = m.MerchantID " +
                                    "WHERE p.ProductName LIKE ?";
                            ps = conn.prepareStatement(sql);
                            ps.setString(1, "%" + searchValue + "%");
                        }

                        rs = ps.executeQuery();

                        while (rs.next()) {
                            Product product = new Product();
                            product.setProductId(rs.getInt("ProductID"));
                            product.setProductName(rs.getString("ProductName"));
                            product.setCategory(rs.getString("Category"));
                            product.setPrice(rs.getDouble("Price"));
                            product.setStock(rs.getInt("Stock"));
                            product.setMerchantId(rs.getInt("MerchantID"));
                            product.setMerchantName(rs.getString("merchant_name"));
                            products.add(product);
                        }

                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            %>

            <% if (products.isEmpty()) { %>
            <div class="empty-state">
                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
                    <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                </svg>
                <% if (searchType != null && searchValue != null && !searchValue.trim().isEmpty()) { %>
                <p>未找到相关商品</p>
                <% } else { %>
                <p>搜索商品以查看列表</p>
                <% } %>
            </div>
            <% } else { %>
            <% for (Product product : products) { %>
            <div class="product-card" data-product-id="<%= product.getProductId() %>">
                <div class="product-image">
                    <%= product.getProductId() %>
                </div>
                <div class="product-details">
                    <div class="product-name"><%= product.getProductName() %></div>
                    <div class="product-info">
                        <div>类别: <%= product.getCategory() %></div>
                        <div>库存: <%= product.getStock() %>件</div>
                        <div>商家: <%= product.getMerchantName() != null ? product.getMerchantName() : "未知" %></div>
                    </div>
                    <div class="product-price">¥<%= String.format("%.2f", product.getPrice()) %></div>
                </div>
                <button class="btn btn-add add-to-cart" data-product-id="<%= product.getProductId() %>">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-bag-plus" viewBox="0 0 16 16">
                        <path d="M8 1a2.5 2.5 0 0 1 2.5 2.5V4h-5v-0.5A2.5 2.5 0 0 1 8 1zm0 4a1.5 1.5 0 0 0-1.5 1.5v5A1.5 1.5 0 0 0 8 12a1.5 1.5 0 0 0 1.5-1.5v-5A1.5 1.5 0 0 0 8 5zm0 5a0.5.5 0 0 1 0 1 0.5.5 0 0 1 0 1 0.5.5 0 0 1 0 1 0.5.5 0 0 1 0 1 0.5.5 0 0 1 0 1H8a.5.5 0 0 1 0-1 .5.5 0 0 1 0-1 .5.5 0 0 1 0-1 .5.5 0 0 1 0-1 .5.5 0 0 1 0-1z"/>
                        <path d="M12.5 3.5a.5.5 0 0 0-1 0V4h-1a.5.5 0 0 0 0 1h1v1a.5.5 0 0 0 1 0V5h1a.5.5 0 0 0 0-1h-1V3.5z"/>
                    </svg>
                    加入购物车
                </button>
            </div>
            <% } %>
            <% } %>
        </div>
    </div>
</div>

<script>
    // 页面加载完成后初始化事件处理
    document.addEventListener('DOMContentLoaded', function() {
        // 初始化加入购物车按钮事件
        initAddToCartButtons();

        // 回车键搜索
        const searchValue = document.getElementById('searchValue');
        searchValue.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('searchForm').submit();
            }
        });
    });

    // 初始化加入购物车按钮事件
    function initAddToCartButtons() {
        document.querySelectorAll('.add-to-cart').forEach(button => {
            button.addEventListener('click', function() {
                const productId = this.getAttribute('data-product-id');
                window.location.href = "go.jsp?productId=" + productId;
            });
        });
    }
</script>
</body>
</html>

<%-- 商品类定义 --%>
<%!
    class Product {
        private int productId;
        private String productName;
        private String category;
        private double price;
        private int stock;
        private int merchantId;
        private String merchantName;

        // Getters and Setters
        public int getProductId() { return productId; }
        public void setProductId(int productId) { this.productId = productId; }

        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }

        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }

        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }

        public int getStock() { return stock; }
        public void setStock(int stock) { this.stock = stock; }

        public int getMerchantId() { return merchantId; }
        public void setMerchantId(int merchantId) { this.merchantId = merchantId; }

        public String getMerchantName() { return merchantName; }
        public void setMerchantName(String merchantName) { this.merchantName = merchantName; }
    }
%>