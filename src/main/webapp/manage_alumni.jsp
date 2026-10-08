<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Alumni Management</title>
    <style>
        body { background: #020617; color: white; font-family: sans-serif; padding: 40px; }
        .container { background: rgba(30, 41, 59, 0.4); border-radius: 20px; padding: 40px; border: 1px solid rgba(255,255,255,0.1); }
        .search-input, .form-input { background: #1e293b; border: 1px solid #334155; color: white; padding: 10px; border-radius: 8px; width: 100%; box-sizing: border-box; }
        .btn-add { background: #10b981; color: white; padding: 10px 20px; border-radius: 8px; cursor: pointer; border: none; font-weight: bold; }
        .add-form { background: rgba(15, 23, 42, 0.9); padding: 25px; border-radius: 12px; margin-bottom: 25px; display: none; border: 1px solid #38bdf8; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { text-align: left; color: #38bdf8; padding: 12px; border-bottom: 1px solid #334155; }
        td { padding: 12px; border-bottom: 1px solid #1e293b; color: #cbd5e1; }
    </style>
    <script>
        function toggleAddForm() {
            var f = document.getElementById("inlineAddForm");
            f.style.display = (f.style.display === "none" || f.style.display === "") ? "block" : "none";
        }
    </script>
</head>
<body>
    <div class="container">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
            <h1 style="margin:0;">Alumni <span style="color:#38bdf8;">Records</span></h1>
            <button onclick="toggleAddForm()" class="btn-add">Add Alumni +</button>
        </div>

        <div id="inlineAddForm" class="add-form">
            <h3 style="color:#38bdf8; margin-top:0;">New Alumni Details</h3>
            <form action="AlumniHandler" method="POST" style="display:grid; grid-template-columns: 1fr 1fr 1fr; gap:15px;">
                <input type="hidden" name="action" value="add">
                <input type="text" name="first_name" placeholder="First Name" class="form-input" required>
                <input type="text" name="last_name" placeholder="Last Name" class="form-input" required>
                <input type="email" name="email" placeholder="Email" class="form-input" required>
                <input type="text" name="graduation_year" placeholder="Graduation Year" class="form-input">
                <input type="text" name="department" placeholder="Department" class="form-input">
                <input type="text" name="current_location" placeholder="Location" class="form-input">
                <input type="text" name="username" placeholder="Username" class="form-input" required>
                <input type="password" name="password" placeholder="Password" class="form-input" required>
                <button type="submit" class="btn-add" style="grid-column: span 3;">Create Account</button>
            </form>
        </div>

        <form action="AlumniHandler" method="GET" style="margin-bottom: 20px; display: flex; gap: 10px;">
            <input type="text" name="search" class="search-input" style="width: 300px;" placeholder="Search by name or email..." value="${param.search}">
            <button type="submit" style="background:#38bdf8; border:none; padding:10px 20px; border-radius:8px; color:white; cursor:pointer; font-weight: bold;">Search</button>
        </form>

        <table>
            <thead>
                <tr><th>ID</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Action</th></tr>
            </thead>
            <tbody>
                <% 
                List<Map<String, String>> data = (List<Map<String, String>>) request.getAttribute("dataList");
                if (data != null && !data.isEmpty()) {
                    for (Map<String, String> row : data) { 
                %>
                <tr>
                    <td>#<%= row.get("alumni_id") %></td>
                    <td><%= row.get("first_name") %></td>
                    <td><%= row.get("last_name") %></td>
                    <td><%= row.get("email") %></td>
                    <td>
                        <form action="AlumniHandler" method="POST" style="display:inline;" onsubmit="return confirm('Permanently delete this alumnus?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= row.get("alumni_id") %>">
                            <button type="submit" style="color:#f87171; background:none; border:1px solid #f87171; border-radius:5px; padding:3px 10px; cursor:pointer;">Delete</button>
                        </form>
                    </td>
                </tr>
                <% } } else { %>
                <tr><td colspan="5" style="text-align:center; padding:30px; color: #64748b;">No alumni found.</td></tr>
                <% } %>
            </tbody>
        </table>
        <br>
        <a href="admin_dashboard.jsp" style="color:#38bdf8; text-decoration:none; font-weight: bold;">← Back to Dashboard</a>
    </div>
</body>
</html>