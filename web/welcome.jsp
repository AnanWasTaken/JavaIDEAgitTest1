<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>欢迎登录线上商城</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            text-align: center;
            padding: 50px;
        }
        .welcome-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 40px;
            max-width: 600px;
            margin: 0 auto;
        }
        h1 {
            color: #419fed;
            margin-bottom: 20px;
        }
        p {
            font-size: 18px;
            margin-bottom: 30px;
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
            margin: 5px;
            color: white;
            font-weight: 500;
        }
        .button-primary {
            background-color: #419fed;
        }
        .button-primary:hover {
            background-color: #2c88d4;
        }
        .button-danger {
            background-color: #f44336; /* 红色背景 */
        }
        .button-danger:hover {
            background-color: #d32f2f; /* 深红色悬停效果 */
        }
    </style>
</head>
<body>
<div class="welcome-container">
    <h1>成功登录线上商城，欢迎！</h1>
    <p>您好，<%= session.getAttribute("Account") %>，很高兴见到您！</p>
    <p>请选择您想进行的操作：</p>
    <a href="select.html" class="button button-primary">查询商品</a>
    <a href="updateGood.jsp" class="button button-primary">更改商品</a>
    <a href="my.jsp" class="button button-primary">我的</a>
    <a href="logout.jsp" class="button button-danger">退出登录</a>
</div>
</body>
</html>