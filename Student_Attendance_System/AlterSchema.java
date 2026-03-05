import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class AlterSchema {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/smart_attendance";
        String user = "root";
        String pass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, pass);
            Statement stmt = conn.createStatement();
            
            // Alter lecture_date to be a VARCHAR to store days like "Monday"
            stmt.executeUpdate("ALTER TABLE lectures MODIFY lecture_date VARCHAR(20)");
            
            System.out.println("Successfully altered lectures table!");
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
