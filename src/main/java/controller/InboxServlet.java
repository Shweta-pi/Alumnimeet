package controller;
import dao.NetworkDao;
import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/InboxServlet")
public class InboxServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer myId = (Integer) request.getSession().getAttribute("userId");
        if (myId == null) { response.sendRedirect("login.html"); return; }

        NetworkDao dao = new NetworkDao();
        request.setAttribute("contacts", dao.getMyContacts(myId));
        request.getRequestDispatcher("messages.jsp").forward(request, response);
    }
}