package controller;

import dao.NetworkDao;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/NetworkHandler")
public class NetworkHandler extends HttpServlet {
    private NetworkDao dao = new NetworkDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer myId = (Integer) session.getAttribute("userId");
        
        if (myId == null) {
            response.sendRedirect("login.html");
            return;
        }

        // 1. Fetch Incoming Requests (For the "Accept" section)
        request.setAttribute("incomingRequests", dao.getIncomingRequests(myId));

        // 2. Fetch Alumni List (For the "Connect" section with Search)
        String nameQuery = request.getParameter("searchQuery");
        String yearQuery = request.getParameter("searchYear");
        List<Map<String, String>> alumni = dao.searchAlumni(myId, nameQuery, yearQuery);
        
        request.setAttribute("alumniList", alumni);
        request.getRequestDispatcher("network.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer myId = (Integer) session.getAttribute("userId");
        
        if (myId == null) {
            response.sendRedirect("login.html");
            return;
        }

        String action = request.getParameter("action");

        if ("accept".equals(action)) {
            String connIdStr = request.getParameter("connectionId");
            if (connIdStr != null) {
                dao.acceptConnection(Integer.parseInt(connIdStr));
            }
        } else {
            String receiverIdStr = request.getParameter("receiverId");
            if (receiverIdStr != null) {
                dao.sendRequest(myId, Integer.parseInt(receiverIdStr));
            }
        }
        
        response.sendRedirect("NetworkHandler");
    } 
}