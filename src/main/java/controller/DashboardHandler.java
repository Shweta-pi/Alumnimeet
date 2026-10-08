
package controller; // Based on your project explorer

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Ensure you import your DB connection class
import dao.DBConnection;


@WebServlet("/DashboardHandler")
public class DashboardHandler extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Fix: Use a safer way to get the ID. Adjust "uid" to match your LoginHandler session key
        Object idObj = session.getAttribute("uid"); 
        if (idObj == null) {
            response.sendRedirect("login.html");
            return;
        }
        int alumniId = Integer.parseInt(idObj.toString());

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Fetch Connection Count
            PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM connections WHERE user_id = ?");
            ps1.setInt(1, alumniId);
            ResultSet rs1 = ps1.executeQuery();
            request.setAttribute("connectionCount", rs1.next() ? rs1.getInt(1) : 0);

            // 2. Fetch Job Postings Count
            PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM jobs WHERE poster_id = ?");
            ps2.setInt(1, alumniId);
            ResultSet rs2 = ps2.executeQuery();
            request.setAttribute("jobCount", rs2.next() ? rs2.getInt(1) : 0);

            // 3. Fetch Events from your interaction table
            List<String> events = new ArrayList<>();
            String eventSql = "SELECT e.event_name FROM event e " +
                             "JOIN alumni_event_interaction i ON e.event_id = i.event_id " +
                             "WHERE i.user_id = ?";
            PreparedStatement ps3 = conn.prepareStatement(eventSql);
            ps3.setInt(1, alumniId);
            ResultSet rs3 = ps3.executeQuery();
            while(rs3.next()) {
                events.add(rs3.getString("event_name"));
            }
            request.setAttribute("attendingEvents", events);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
        }
        
        // Ensure path matches your project structure
        request.getRequestDispatcher("alumni_dashboard.jsp").forward(request, response);
    }
}