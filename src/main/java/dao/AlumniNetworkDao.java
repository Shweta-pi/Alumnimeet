package dao;
import java.sql.*;
import java.util.*;

public class AlumniNetworkDao {
    private String url = "jdbc:mysql://localhost:3306/alumnidb";
    private String user = "root";
    private String pass = "root";

    public List<Map<String, String>> searchAlumniWithStatus(String query, int currentUserId) {
        List<Map<String, String>> list = new ArrayList<>();
        // JOINS alumni with connections to fetch names and status
        String sql = "SELECT a.alumni_id, a.first_name, a.graduation_year, c.status " +
                     "FROM alumni a LEFT JOIN connections c " +
                     "ON (c.connected_with_id = a.alumni_id AND c.user_id = ?) " +
                     "WHERE a.alumni_id != ? AND (a.first_name LIKE ? OR a.graduation_year LIKE ?)";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(url, user, pass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, currentUserId);
                ps.setInt(2, currentUserId);
                String search = "%" + (query == null ? "" : query) + "%";
                ps.setString(3, search);
                ps.setString(4, search);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, String> person = new HashMap<>();
                    person.put("id", rs.getString("alumni_id"));
                    person.put("name", rs.getString("first_name"));
                    person.put("year", rs.getString("graduation_year"));
                    person.put("status", rs.getString("status") == null ? "Connect" : rs.getString("status"));
                    list.add(person);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void initiateConnection(int senderId, int receiverId) {
        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            // Insert into connections and messages tables
            String connSql = "INSERT INTO connections (user_id, connected_with_id, status) VALUES (?, ?, 'Pending')";
            PreparedStatement ps1 = con.prepareStatement(connSql);
            ps1.setInt(1, senderId);
            ps1.setInt(2, receiverId);
            ps1.executeUpdate();

            String msgSql = "INSERT INTO messages (sender_id, receiver_id, message_content, sent_at) VALUES (?, ?, 'Request to connect', NOW())";
            PreparedStatement ps2 = con.prepareStatement(msgSql);
            ps2.setInt(1, senderId);
            ps2.setInt(2, receiverId);
            ps2.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}