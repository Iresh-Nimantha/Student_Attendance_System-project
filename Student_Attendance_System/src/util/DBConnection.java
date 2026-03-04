package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/smart_attendance";
    private static final String USER = "root"; // Update with actual DB user
    private static final String PASSWORD = ""; // Update with actual DB password

    public static Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database connected successfully!");
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found. " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Failed to connect to MySQL database. " + e.getMessage());
        }
        return connection;
    }
}
