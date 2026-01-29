<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>商品管理</title>
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
        .container {
            max-width: 800px;
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
            padding: 20px 30px;
            text-align: center;
        }

        .header h1 {
            font-size: 22px;
            margin-bottom: 5px;
        }

        /* 内容区域样式 */
        .content {
            padding: 30px;
        }

        /* 表单样式 */
        .form-group {
            margin-bottom: 20px;
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
            min-height: 100px;
            resize: vertical;
        }

        /* 按钮样式 */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 18px;
            border: none;
            border-radius: 5px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            gap: 8px;
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

        .btn-danger {
            background-color: #f4516c;
            color: white;
        }

        .btn-danger:hover {
            background-color: #e63955;
        }

        /* 按钮组样式 */
        .btn-group {
            display: flex;
            gap: 10px;
            margin: 20px 0;
        }

        /* 表格样式 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e9f0f9;
        }

        th {
            background-color: #f0f5ff;
            color: #4a90e2;
            font-weight: 600;
        }

        tr:hover {
            background-color: #f9fcff;
        }

        /* 消息提示样式 */
        .message {
            margin: 15px 0;
            padding: 10px;
            border-radius: 5px;
            color: #842029;
            background-color: #f8d7da;
            border: 1px solid #f5c2c7;
        }

        /* 响应式设计 */
        @media (max-width: 600px) {
            .container {
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
<div class="container">
    <div class="header">
        <h1>商品管理系统</h1>
    </div>

    <div class="content">
        <!-- 查询表单 -->
        <form action="editByIDS.jsp" method="post" class="form-group">
            <div style="display: flex; gap: 10px;">
                <label for="productID">按ID查询:</label>
                <input type="text" id="productID" name="productID" placeholder="输入商品ID">
                <button type="submit" class="btn btn-primary">
                    查询
                </button>
            </div>
        </form>

        ${message}

        <!-- 按钮组 -->
        <div class="btn-group">
            <a href="addGood.jsp" class="btn btn-primary">
                添加新商品
            </a>
            <a href="welcome.jsp" class="btn btn-secondary">
                返回首页
            </a>
        </div>

        <!-- 编辑表单 -->
        <form action="updateGood.jsp" method="post" class="form-group">
            <table>
                <tr>
                    <th>编号</th>
                    <td><input type="text" name="productID" value="${good.productID}" readonly></td>
                </tr>
                <tr>
                    <th>商品名</th>
                    <td><input type="text" name="productName" value="${good.productName}"></td>
                </tr>
                <tr>
                    <th>类别</th>
                    <td><textarea name="category">${good.category}</textarea></td>
                </tr>
                <tr>
                    <th>价格</th>
                    <td><input type="text" name="price" value="${good.price}"></td>
                </tr>
                <tr>
                    <th>库存</th>
                    <td><input type="text" name="stock" value="${good.stock}"></td>
                </tr>
                <tr>
                    <td colspan="2" style="display: flex; gap: 10px; padding-top: 10px;">
                        <button type="submit" class="btn btn-primary">
                            更新
                        </button>
                        <a href="delGood.jsp?productID=${good.productID}" class="btn btn-danger">
                            删除
                        </a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
</body>
</html>
