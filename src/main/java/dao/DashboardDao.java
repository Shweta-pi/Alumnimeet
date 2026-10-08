package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DashboardDao {

    public int getConnectionCount(int alumniId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM connections WHERE user_id = ?";
        // Fix: Changed DBconnection to DBConnection
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, alumniId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int getJobPostingCount(int alumniId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM jobs WHERE poster_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, alumniId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<String> getAttendingEvents(int alumniId) {
        List<String> events = new ArrayList<>();
        String sql = "SELECT e.event_name FROM event e " +
                     "JOIN alumni_event_interaction i ON e.event_id = i.event_id " +
                     "WHERE i.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, alumniId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                events.add(rs.getString("event_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return events;
    }
}