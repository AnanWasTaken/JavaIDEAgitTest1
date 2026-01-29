<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>个人中心</title>
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
      max-width: 600px;
      width: 100%;
      background: white;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(50, 100, 200, 0.1);
      overflow: hidden;
      text-align: center;
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

    /* 按钮样式 */
    .btn-group {
      display: flex;
      flex-direction: column;
      gap: 20px;
      margin-top: 30px;
    }

    .btn {
      padding: 16px 20px;
      border: none;
      border-radius: 8px;
      font-size: 18px;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.3s ease;
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 12px;
      text-decoration: none;
      color: white;
    }

    .btn-cart {
      background-color: #ff7d00;
    }

    .btn-cart:hover {
      background-color: #e67300;
      transform: translateY(-2px);
      box-shadow: 0 4px 10px rgba(255, 125, 0, 0.3);
    }

    .btn-order {
      background-color: #00b42a;
    }

    .btn-order:hover {
      background-color: #009e25;
      transform: translateY(-2px);
      box-shadow: 0 4px 10px rgba(0, 180, 42, 0.3);
    }

    .btn-shop {
      background-color: #4a90e2;
    }

    .btn-shop:hover {
      background-color: #357abd;
      transform: translateY(-2px);
      box-shadow: 0 4px 10px rgba(74, 144, 226, 0.3);
    }

    .btn-back {
      background-color: #f44336; /* 红色返回按钮 */
      margin-top: 30px;
    }

    .btn-back:hover {
      background-color: #d32f2f;
      transform: translateY(-2px);
      box-shadow: 0 4px 10px rgba(244, 67, 54, 0.3);
    }

    .btn i {
      font-size: 20px;
    }

    /* 响应式设计 */
    @media (min-width: 600px) {
      .btn-group {
        flex-direction: row;
        justify-content: space-between;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <div class="header">
    <h1>个人中心</h1>
    <p>管理您的购物和订单</p>
  </div>

  <div class="content">
    <h3>我的购物</h3>
    <p>快速访问您的购物车和订单</p>

    <div class="btn-group">
      <a href="trolley_delete.jsp" class="btn btn-cart">
        我的购物车
      </a>

      <a href="order.jsp" class="btn btn-order">
        待收货订单
      </a>

      <a href="buy.jsp" class="btn btn-shop">
        继续购物
      </a>
    </div>

    <!-- 返回按钮 -->
    <a href="welcome.jsp" class="btn btn-back">
      返回首页
    </a>
  </div>
</div>
</body>
</html>