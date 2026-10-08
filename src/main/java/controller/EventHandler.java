package controller;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.EventDAO;

@WebServlet("/EventHandler")
public class EventHandler extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private EventDAO dao = new EventDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Map<String, String>> eventList = dao.getAllEvents();
        request.setAttribute("eventList", eventList);
        request.getRequestDispatcher("manage_events.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                dao.addEvent(
                    request.getParameter("name"), 
                    request.getParameter("desc"), 
                    request.getParameter("date"), 
                    request.getParameter("loc"), 
                    Integer.parseInt(request.getParameter("orgId"))
                );
            } else if ("delete".equals(action)) {
                dao.deleteEvent(Integer.parseInt(request.getParameter("id")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        
        response.sendRedirect(request.getContextPath() + "/EventHandler");
    }
}