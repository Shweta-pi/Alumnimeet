package dao;

import java.sql.*;
import java.util.*;

public class ConnectionProviderDao {
	private String url = "jdbc:mysql://localhost:3306/alumnidb";
    private String user = "root";
    private String pass = "root";

    public List<Map<String, String>> getAlumniWithConnectionStatus(String query) {
        List<Map<String, String>> list = new ArrayList<>();
        // Querying your alumni table for name and graduation year
        String sql = "SELECT alumni_id, first_name, graduation_year FROM alumni " +
                     "WHERE first_name LIKE ? OR graduation_year LIKE ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(url, user, pass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                
                String search = "%" + query + "%";
                ps.setString(1, search);
                ps.setString(2, search);

                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("id", rs.getString("alumni_id"));
                    map.put("name", rs.getString("first_name"));
                    map.put("gradYear", rs.getString("graduation_year"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}