import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class InspectDB {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/smart_attendance";
        String user = "root";
        String pass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, pass);
            Statement stmt = conn.createStatement();
            
            // Check Users Count
            System.out.println("--- USERS TABLE ---");
            ResultSet rsUsers = stmt.executeQuery("SELECT COUNT(*) FROM users");
            if (rsUsers.next()) {
                System.out.println("Total Users: " + rsUsers.getInt(1));
            }
            
            // Check Lectures Schema
            System.out.println("\n--- LECTURES SCHEMA ---");
            ResultSet rsLectures = stmt.executeQuery("DESCRIBE lectures");
            while (rsLectures.next()) {
                System.out.println(rsLectures.getString("Field") + " : " + rsLectures.getString("Type"));
            }
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
