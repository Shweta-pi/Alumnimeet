package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    // Database credentials from your MySQL instance
    private static final String URL = "jdbc:mysql://localhost:3306/alumnidb";
    private static final String USER = "root";
    private static final String PASS = "root"; // Update this to your MySQL password

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Using the driver found in your lib folder
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}