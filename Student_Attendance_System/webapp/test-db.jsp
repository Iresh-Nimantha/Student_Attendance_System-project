<%@ page import="java.sql.*" %>
    <%@ page import="java.io.*" %>
        <html>

        <body>
            <h2>Test DB Connection in Tomcat</h2>
            <% String url="jdbc:mysql://localhost:3306/smart_attendance" ; String user="root" ; String pass="" ; try {
                Class.forName("com.mysql.cj.jdbc.Driver"); out.println("Driver loaded successfully.<br>");
                Connection conn = DriverManager.getConnection(url, user, pass);
                out.println("Connection successful!<br>");
                conn.close();
                } catch (ClassNotFoundException e) {
                out.println("ClassNotFoundException: " + e.getMessage() + "<br>");
                } catch (SQLException e) {
                out.println("SQLException: " + e.getMessage() + "<br>");
                } catch (Exception e) {
                out.println("Exception: " + e.getMessage() + "<br>");
                }
                %>
        </body>

        </html>