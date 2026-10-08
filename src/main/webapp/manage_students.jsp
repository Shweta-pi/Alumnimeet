<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Management</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap');
        body { background: #0f172a; font-family: 'Inter', sans-serif; color: white; padding: 40px; }
        .card { background: #1e293b; border-radius: 20px; padding: 30px; max-width: 1000px; margin: auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .input-box { background: #334155; border: 1px solid #475569; color: white; padding: 10px; border-radius: 8px; width: 250px; }
        .btn { background: #38bdf8; border: none; padding: 10px 20px; border-radius: 8px; color: white; cursor: pointer; font-weight: 600; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { text-align: left; color: #94a3b8; padding: 15px; border-bottom: 2px solid #334155; }
        td { padding: 15px; border-bottom: 1px solid #334155; }
    </style>
</head>
<body>
<div class="card">
    <div class="header">
        <h2>Student <span style="color:#38bdf8">Portal</span></h2>
        <form action="StudentHandler" method="GET" style="display:flex; gap:10px;">
            <input type="text" name="search" class="input-box" placeholder="Type name..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            <button type="submit" class="btn">Search</button>
        </form>
    </div>

    <table>
        <thead>
            <tr><th>ID</th><th>Full Name</th><th>Email</th><th>Action</th></tr>
        </thead>
        <tbody>
            <% List<Map<String, String>> data = (List<Map<String, String>>) request.getAttribute("dataList");
               if (data != null && !data.isEmpty()) { 
                   for (Map<String, String> row : data) { %>
            <tr>
                <td style="color:#38bdf8">#<%= row.get("student_id") %></td>
                <td><%= row.get("first_name") %> <%= row.get("last_name") %></td>
                <td><%= row.get("email") %></td>
                <td>
                    <form action="StudentHandler" method="POST">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%= row.get("student_id") %>">
                        <button type="submit" style="color:#f87171; background:none; border:1px solid #f87171; padding:5px; border-radius:4px; cursor:pointer;">Delete</button>
                    </form>
                </td>
            </tr>
            <% } } else { %>
            <tr><td colspan="4" style="text-align:center; padding:40px; color:#94a3b8;">No records found matching your search.</td></tr>
            <% } %>
        </tbody>
    </table>
    <br><a href="admin_dashboard.jsp" style="color:#38bdf8; text-decoration:none;">← Dashboard</a>
</div>
</body>
</html>