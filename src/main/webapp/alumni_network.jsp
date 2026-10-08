<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Directory | Alumni Network</title>
    <style>
        body { background: #020617; color: #f8fafc; font-family: sans-serif; padding: 40px; }
        .search-box { text-align: center; margin-bottom: 40px; }
        input { padding: 12px; width: 300px; border-radius: 8px; border: 1px solid #1e293b; background: #0f172a; color: white; }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; }
        .card { background: #1e293b; padding: 20px; border-radius: 12px; border: 1px solid #38bdf8; text-align: center; }
        .btn { background: #38bdf8; border: none; padding: 10px; width: 100%; border-radius: 6px; cursor: pointer; font-weight: bold; margin-top: 10px; }
        .btn-pending { background: #475569; color: #94a3b8; cursor: default; }
    </style>
</head>
<body>
    <div class="search-box">
        <h1>Directory & Networking</h1>
        <form action="NetworkActionServlet" method="get">
            <input type="text" name="searchQuery" placeholder="Search name or year..." value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "" %>">
            <button type="submit" class="btn" style="width: auto;">Search</button>
        </form>
    </div>

    <div class="grid">
        <% 
            List<Map<String, String>> results = (List<Map<String, String>>) request.getAttribute("results");
            if (results != null && !results.isEmpty()) {
                for (Map<String, String> person : results) {
                    boolean isPending = "Pending".equalsIgnoreCase(person.get("status"));
        %>
            <div class="card">
                <h3><%= person.get("name") %></h3>
                <p>Class of <%= person.get("year") %></p>
                <form action="NetworkActionServlet" method="post">
                    <input type="hidden" name="receiverId" value="<%= person.get("id") %>">
                    <input type="hidden" name="searchQuery" value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "" %>">
                    <button type="submit" class="btn <%= isPending ? "btn-pending" : "" %>" <%= isPending ? "disabled" : "" %>>
                        <%= person.get("status") %>
                    </button>
                </form>
            </div>
        <% } } else { %>
            <p style="grid-column: 1/-1; text-align: center;">No batchmates found.</p>
        <% } %>
    </div>
</body>
</html>