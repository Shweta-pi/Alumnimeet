package controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.Userdao;

@WebServlet("/LoginHandler")
public class LoginHandler extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String role = request.getParameter("role"); 
        String name = request.getParameter("uname");
        String pass = request.getParameter("upass");

        if (role == null || name == null || pass == null) {
            response.sendRedirect("login.html?error=missing_fields");
            return;
        }

        Userdao ud = new Userdao();
        String userDisplayName = ud.validateAndGetName(name, pass, role);

        if (userDisplayName != null) {
            HttpSession session = request.getSession(true); 
            session.setAttribute("fname", userDisplayName); 
            session.setAttribute("role", role);
            
            // Critical for connection and messaging functionality
            int userId = ud.getUserId(name, role);
            session.setAttribute("userId", userId); 

            if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect("admin_dashboard.jsp");
            } else if ("alumni".equalsIgnoreCase(role)) {
                response.sendRedirect("alumni_dashboard.jsp");
            } else {
                response.sendRedirect("student_dashboard.jsp");
            }
        } else {
            // Displays "Invalid credentials" error
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<html><body><div style='text-align:center;color:red;'>");
            out.println("<h2>Invalid credentials for " + role + "</h2>");
            out.println("<a href='login.html'>Try Again</a></div></body></html>");
        }
    }
}