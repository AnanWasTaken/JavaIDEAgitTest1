<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>退出登录</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      text-align: center;
      padding: 50px;
    }
    .logout-container {
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      padding: 40px;
      max-width: 400px;
      margin: 0 auto;
    }
    h1 {
      color: #f44336;
      margin-bottom: 30px;
    }
    p {
      font-size: 18px;
      margin-bottom: 40px;
    }
    .button {
      display: inline-block;
      background-color: #36a9f1;
      color: white;
      padding: 12px 30px;
      text-decoration: none;
      border-radius: 4px;
      font-size: 16px;
      transition: background-color 0.3s;
      border: none;
      cursor: pointer;
    }
    .button:hover {
      background-color: #36a9f1;
    }
  </style>
</head>
<body>
<div class="logout-container">
  <h1>退出登录</h1>
  <p>退出登录成功！</p>

  <%
    // 清除会话中的用户信息
    session.invalidate();
  %>

  <form action="login.jsp" method="get">
    <button type="submit" class="button">确定</button>
  </form>
</div>
</body>
</html>
