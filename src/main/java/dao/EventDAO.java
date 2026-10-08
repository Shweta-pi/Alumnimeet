package dao;

import java.sql.*;
import java.util.*;

public class EventDAO {
    private String url = "jdbc:mysql://localhost:3306/alumnidb"; 
    private String user = "root";
    private String pass = "root"; 

    private Connection getCon() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, pass);
    }

    public List<Map<String, String>> getAllEvents() {
        List<Map<String, String>> list = new ArrayList<>();
        // FIXED: Changed 'events' to 'event' to match your DB screenshot
        String sql = "SELECT * FROM event"; 
        try (Connection con = getCon(); 
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            ResultSetMetaData md = rs.getMetaData();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                for (int i = 1; i <= md.getColumnCount(); i++) {
                    row.put(md.getColumnLabel(i).toLowerCase(), rs.getString(i));
                }
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void addEvent(String name, String desc, String date, String loc, int orgId) {
        // FIXED: Changed 'events' to 'event'
        String sql = "INSERT INTO event (event_name, event_description, event_date, event_location, organizer_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, desc);
            ps.setString(3, date); 
            ps.setString(4, loc);
            ps.setInt(5, orgId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void deleteEvent(int id) {
        // FIXED: Changed 'events' to 'event'
        String sql = "DELETE FROM event WHERE event_id = ?";
        try (Connection con = getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}