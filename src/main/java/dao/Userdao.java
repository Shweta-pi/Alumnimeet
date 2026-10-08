package dao;
import java.sql.*;

public class Userdao {
    private String url = "jdbc:mysql://localhost:3306/alumnidb";
    private String user = "root";
    private String pass = "root";

    // Fixes "method validateAndGetName is undefined"
    public String validateAndGetName(String uname, String upass, String role) {
        String displayName = null; 
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, user, pass);
            
            // Map table and column based on your schema
            String table = role.equalsIgnoreCase("admin") ? "admin" : 
                          (role.equalsIgnoreCase("alumni") ? "alumni" : "students");
            
            String nameCol = role.equalsIgnoreCase("admin") ? "username" : "first_name";
            
            String sql = "SELECT " + nameCol + " FROM " + table + " WHERE username = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, uname);
            ps.setString(2, upass);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                displayName = rs.getString(nameCol); 
            }
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return displayName; 
    }

    // Fixes "method getUserId is undefined"
    public int getUserId(String uname, String role) {
        int id = -1;
        try {
            Connection con = DriverManager.getConnection(url, user, pass);
            String table = role.equalsIgnoreCase("admin") ? "admin" : 
                          (role.equalsIgnoreCase("alumni") ? "alumni" : "students");
            
            // Map primary keys: id, alumni_id, or student_id
            String idCol = role.equalsIgnoreCase("admin") ? "id" : 
                          (role.equalsIgnoreCase("alumni") ? "alumni_id" : "student_id");

            String sql = "SELECT " + idCol + " FROM " + table + " WHERE username = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, uname);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                id = rs.getInt(idCol);
            }
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return id;
    }
}