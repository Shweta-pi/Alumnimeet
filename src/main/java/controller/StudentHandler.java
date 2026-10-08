package controller;

import java.io.IOException;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.StudentDAO;

@WebServlet({"/StudentHandler", "/AlumniHandler"})
public class StudentHandler extends HttpServlet {
    private StudentDAO dao = new StudentDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        String table = path.contains("Student") ? "students" : "alumni";
        String jsp = path.contains("Student") ? "manage_students.jsp" : "manage_alumni.jsp";

        // Capture the search term from the input field
        String search = request.getParameter("search");
        List<Map<String, String>> data;

        if (search != null && !search.trim().isEmpty()) {
            // Call the search logic if a term exists
            data = dao.searchRecords(table, search.trim());
        } else {
            // Default to showing all records
            data = dao.getAllRecords(table);
        }

        request.setAttribute("dataList", data);
        request.getRequestDispatcher(jsp).forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String path = request.getServletPath();

        if ("delete".equals(action)) {
            String table = path.contains("Student") ? "students" : "alumni";
            String idCol = path.contains("Student") ? "student_id" : "alumni_id";
            dao.deleteRecord(table, idCol, request.getParameter("id"));
        } else if ("addStudent".equals(action)) {
            dao.addStudent(request.getParameter("fname"), request.getParameter("lname"), 
                           request.getParameter("email"), request.getParameter("enrollment_year"),
                           request.getParameter("current_location"), request.getParameter("username"), 
                           request.getParameter("password"));
        } else if ("add".equals(action)) {
            dao.addAlumni(request.getParameter("first_name"), request.getParameter("last_name"), 
                          request.getParameter("email"), request.getParameter("graduation_year"),
                          request.getParameter("department"), request.getParameter("current_location"), 
                          request.getParameter("username"), request.getParameter("password"));
        }
        response.sendRedirect(path.substring(1));
    }
}