import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class TestDB {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/smart_attendance";
        String user = "root";
        String password = ""; // try blank

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connection successful to smart_attendance!");
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error 1: " + e.getMessage());
            
            // Try without database
            url = "jdbc:mysql://localhost:3306/";
            try {
                Connection conn = DriverManager.getConnection(url, user, password);
                System.out.println("Connection successful to root MySQL (no db specified)!");
                conn.close();
            } catch (Exception ex) {
                System.out.println("Error 2: " + ex.getMessage());
                
                // Try with common passwords
                String[] passwords = {"root", "1234", "password"};
                for (String pwd : passwords) {
                    try {
                        Connection conn = DriverManager.getConnection(url, user, pwd);
                        System.out.println("SUCCESS with password: " + pwd);
                        conn.close();
                        return;
                    } catch (Exception exc) {}
                }
            }
        }
    }
}
