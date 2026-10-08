package dao;

import java.sql.*;
import java.util.*;

public class StudentDAO {
    private Connection getCon() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/alumnidb", "root", "root");
    }

    public List<Map<String, String>> searchRecords(String table, String query) {
        List<Map<String, String>> list = new ArrayList<>();
        // Fix: Added lower() to SQL to make search case-insensitive
        String sql = "SELECT * FROM " + table + " WHERE lower(first_name) LIKE ? OR lower(last_name) LIKE ? OR lower(email) LIKE ?";
        
        try (Connection con = getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            String pattern = "%" + query.toLowerCase() + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            
            ResultSet rs = ps.executeQuery();
            ResultSetMetaData md = rs.getMetaData();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                for (int i = 1; i <= md.getColumnCount(); i++) {
                    // Force lowercase keys to match row.get() in JSP
                    row.put(md.getColumnName(i).toLowerCase(), rs.getString(i));
                }
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getAllRecords(String table) {
        List<Map<String, String>> list = new ArrayList<>();
        try (Connection con = getCon(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery("SELECT * FROM " + table)) {
            ResultSetMetaData md = rs.getMetaData();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                for (int i = 1; i <= md.getColumnCount(); i++) {
                    row.put(md.getColumnName(i).toLowerCase(), rs.getString(i));
                }
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void addStudent(String f, String l, String e, String y, String loc, String u, String p) {
        String sql = "INSERT INTO students (first_name, last_name, email, enrollment_year, current_location, username, password) VALUES (?,?,?,?,?,?,?)";
        try (Connection con = getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, f); ps.setString(2, l); ps.setString(3, e); ps.setString(4, y); ps.setString(5, loc); ps.setString(6, u); ps.setString(7, p);
            ps.executeUpdate();
        } catch (Exception ex) { ex.printStackTrace(); }
    }

    public void addAlumni(String f, String l, String e, String y, String d, String loc, String u, String p) {
        String sql = "INSERT INTO alumni (first_name, last_name, email, graduation_year, department, current_location, username, password) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection con = getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, f); ps.setString(2, l); ps.setString(3, e); ps.setString(4, y); ps.setString(5, d); ps.setString(6, loc); ps.setString(7, u); ps.setString(8, p);
            ps.executeUpdate();
        } catch (Exception ex) { ex.printStackTrace(); }
    }

    public void deleteRecord(String table, String col, String id) {
        try (Connection con = getCon(); PreparedStatement ps = con.prepareStatement("DELETE FROM "+table+" WHERE "+col+" = ?")) {
            ps.setString(1, id); ps.executeUpdate();
        } catch (Exception ex) { ex.printStackTrace(); }
    }
}