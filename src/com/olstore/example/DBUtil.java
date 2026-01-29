package com.olstore.example;

import java.sql.*;

public class DBUtil {
    private final static String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private final static String url = "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=test1;Encrypt=true;trustServerCertificate=true";
    private final static String user = "sa";
    private final static String password = "123456";
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Connection conn = null;
        Class.forName(Driver);
        return DriverManager.getConnection(url,user,password);
    }

    public static void closeConnection(Connection conn, Statement stmt, ResultSet rs) throws SQLException {
        if(conn != null) conn.close();
        if(stmt != null) stmt.close();
        if(rs !=null) rs.close();
    }
}