package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterHandler")
public class RegisterHandler extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
       
        String role = request.getParameter("role");
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String email = request.getParameter("uemail");
        String uname = request.getParameter("uname");
        String upass = request.getParameter("upass");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/alumnidb", "root", "root");

            PreparedStatement ps = null;

            if ("alumni".equalsIgnoreCase(role)) {
                String gradYear = request.getParameter("grad_year");
                String dept = request.getParameter("dept");

                String sql = "INSERT INTO alumni (first_name, last_name, email, graduation_year, department, username, password) VALUES (?, ?, ?, ?, ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, fname);
                ps.setString(2, lname);
                ps.setString(3, email);
                ps.setString(4, gradYear);
                ps.setString(5, dept);
                ps.setString(6, uname);
                ps.setString(7, upass);

            } else if ("student".equalsIgnoreCase(role)) {
                String enrollYear = request.getParameter("enroll_year");

                
                String sql = "INSERT INTO students (first_name, last_name, email, enrollment_year, username, password) VALUES (?, ?, ?, ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, fname);
                ps.setString(2, lname);
                ps.setString(3, email);
                ps.setString(4, enrollYear);
                ps.setString(5, uname);
                ps.setString(6, upass);
            }

            int result = ps.executeUpdate();

            out.print("<html><body style='font-family: Arial, sans-serif; text-align: center; margin-top: 50px;'>");
            if (result > 0) {
                out.print("<h2 style='color:green;'>Registration Successful for " + role + "!</h2>");
                out.print("<p>Welcome, " + fname + ". You can now log in.</p>");
                out.print("<a href='login.html' style='text-decoration:none; color:#1c3161; font-weight:bold;'>Go to Login</a>");
            } else {
                out.print("<h2 style='color:red;'>Registration Failed. Please try again.</h2>");
                out.print("<a href='register.html'>Back to Registration</a>");
            }
            out.print("</body></html>");

        } catch (Exception e) {
            out.print("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
            e.printStackTrace();
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("register.html");
    }
}