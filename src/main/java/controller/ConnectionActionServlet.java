package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ConnectionActionServlet")
public class ConnectionActionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer currentUserId = (Integer) session.getAttribute("userId"); // Ensure this is set in LoginHandler
        
        String requesterIdStr = request.getParameter("requesterId");
        String action = request.getParameter("action"); // 'accept' or 'reject'

        if (currentUserId == null || requesterIdStr == null) {
            response.sendRedirect("login.html");
            return;
        }

        int requesterId = Integer.parseInt(requesterIdStr);

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/alumnidb", "root", "root")) {
            if ("accept".equals(action)) {
                // 1. Update existing request to 'accepted'
                String sqlUpdate = "UPDATE connections SET status = 'accepted' WHERE user_id = ? AND connected_with_id = ?";
                PreparedStatement ps1 = con.prepareStatement(sqlUpdate);
                ps1.setInt(1, requesterId);
                ps1.setInt(2, currentUserId);
                ps1.executeUpdate();

                // 2. Create reciprocal connection so both see each other as connected
                String sqlInsert = "INSERT INTO connections (user_id, connected_with_id, status) VALUES (?, ?, 'accepted') " +
                                 "ON DUPLICATE KEY UPDATE status='accepted'";
                PreparedStatement ps2 = con.prepareStatement(sqlInsert);
                ps2.setInt(1, currentUserId);
                ps2.setInt(2, requesterId);
                ps2.executeUpdate();
            } else {
                // Handle rejection by removing the record
                String sqlDelete = "DELETE FROM connections WHERE user_id = ? AND connected_with_id = ?";
                PreparedStatement ps3 = con.prepareStatement(sqlDelete);
                ps3.setInt(1, requesterId);
                ps3.setInt(2, currentUserId);
                ps3.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("NetworkHandler");
    }
}