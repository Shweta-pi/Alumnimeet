package dao;
import java.sql.*;
import java.util.*;

public class NetworkDao {
    private String url = "jdbc:mysql://localhost:3306/alumnidb";
    private String user = "root";
    private String pass = "root";

    public List<Map<String, String>> searchAlumni(int currentUserId, String query, String year) {
        List<Map<String, String>> alumniList = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT a.alumni_id, a.first_name, a.graduation_year, c.status " +
            "FROM alumni a LEFT JOIN connections c ON a.alumni_id = c.connected_with_id AND c.user_id = ? " +
            "WHERE a.alumni_id != ?"
        );

        if (query != null && !query.isEmpty()) sql.append(" AND a.first_name LIKE ?");
        if (year != null && !year.isEmpty()) sql.append(" AND a.graduation_year LIKE ?");

        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            PreparedStatement ps = con.prepareStatement(sql.toString());
            ps.setInt(1, currentUserId);
            ps.setInt(2, currentUserId);
            int idx = 3;
            if (query != null && !query.isEmpty()) ps.setString(idx++, "%" + query + "%");
            if (year != null && !year.isEmpty()) ps.setString(idx++, "%" + year + "%");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> a = new HashMap<>();
                a.put("id", rs.getString("alumni_id"));
                a.put("name", rs.getString("first_name"));
                a.put("year", rs.getString("graduation_year"));
                a.put("status", rs.getString("status") == null ? "Connect" : rs.getString("status"));
                alumniList.add(a);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return alumniList;
    }

    // --- UPDATED SENDREQUEST (FIXED DUPLICATE ISSUE) ---
    public void sendRequest(int senderId, int receiverId) {
        // Step 1: Check if a request already exists to prevent duplicates
        String checkSql = "SELECT COUNT(*) FROM connections WHERE user_id = ? AND connected_with_id = ?";
        String insertSql = "INSERT INTO connections (user_id, connected_with_id, status) VALUES (?, ?, 'Pending')";
        
        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setInt(1, senderId);
            checkPs.setInt(2, receiverId);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next() && rs.getInt(1) == 0) {
                // Step 2: Only insert if no previous request exists
                PreparedStatement insertPs = con.prepareStatement(insertSql);
                insertPs.setInt(1, senderId);
                insertPs.setInt(2, receiverId);
                insertPs.executeUpdate();
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

    public List<Map<String, String>> getChatHistory(int user1, int user2) {
        List<Map<String, String>> history = new ArrayList<>();
        String sql = "SELECT * FROM messages WHERE (sender_id = ? AND receiver_id = ?) " +
                     "OR (sender_id = ? AND receiver_id = ?) ORDER BY sent_at ASC";
        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, user1); ps.setInt(2, user2);
            ps.setInt(3, user2); ps.setInt(4, user1);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("senderId", rs.getString("sender_id"));
                m.put("content", rs.getString("message_content"));
                history.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return history;
    }

    public List<Map<String, String>> getMyContacts(int myId) {
        List<Map<String, String>> contacts = new ArrayList<>();
        String sql = "SELECT a.alumni_id, a.first_name FROM alumni a " +
                     "JOIN connections c ON a.alumni_id = c.connected_with_id " +
                     "WHERE c.user_id = ? AND c.status = 'Accepted'";
        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, myId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> c = new HashMap<>();
                c.put("id", rs.getString("alumni_id"));
                c.put("name", rs.getString("first_name"));
                contacts.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return contacts;
    }

    public List<Map<String, String>> getIncomingRequests(int myId) {
        List<Map<String, String>> requests = new ArrayList<>();
        String sql = "SELECT c.connection_id, a.first_name, a.graduation_year " +
                     "FROM connections c JOIN alumni a ON c.user_id = a.alumni_id " +
                     "WHERE c.connected_with_id = ? AND c.status = 'Pending'";
        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, myId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> r = new HashMap<>();
                r.put("connectionId", rs.getString("connection_id"));
                r.put("senderName", rs.getString("first_name"));
                r.put("year", rs.getString("graduation_year"));
                requests.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return requests;
    }

    public void acceptConnection(int connectionId) {
        String sql = "UPDATE connections SET status = 'Accepted' WHERE connection_id = ?";
        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, connectionId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}