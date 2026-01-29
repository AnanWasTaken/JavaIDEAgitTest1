<%-- 
    Document   : insertfont
    Created on : 2025-5-17, 16:35:00
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
      <div style=" width: 500px; height: 400px ; margin: 0 auto">
                 ${message}
            <form action="insertGood.jsp" method="post">
                <table  border="1">
                 <tr><td>商品名</td> 
                    <td> <input type="text"  name="ProductName"/>
                    </td>
                </tr>
                 <tr><td>类别</td>
                    <td> <input type="text"  name="Category" />
                    </td>
                </tr>
                 <tr><td>价格</td>
                    <td> <input type="text"  name="Price" />
                    </td>
                </tr>
                 <tr><td>库存</td>
                    <td> <input type="text"  name="Stock" />
                    </td>
                </tr>
                <tr><td>分类ID</td> 
                    <td> <input type="text"  name="CategoryID"/>
                    </td>
                </tr>
                <tr><td>商家ID</td> 
                    <td> <input type="text"  name="MerchantID"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit"  value="添加"/><input type="reset" value="重置"/> </td>
                    
                </tr>
            </table>
            
            </form>
        </div>
    </body>
</html>
