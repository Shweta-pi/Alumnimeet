<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>ALUMNI NETWORK</title>
    <style>
        body { background: #020617; color: white; font-family: 'Inter', sans-serif; margin: 0; }
        .header { border-bottom: 2px solid #fbbf24; padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; }
        .container { padding: 40px; max-width: 1200px; margin: auto; }
        .search-bar { margin-bottom: 30px; display: flex; gap: 10px; }
        .search-bar input { background: #1e293b; border: 1px solid #334155; color: white; padding: 12px; border-radius: 8px; flex: 1; }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 25px; }
        .card { background: rgba(30, 41, 59, 0.7); padding: 30px; border-radius: 15px; border: 1px solid rgba(251, 191, 36, 0.1); text-align: center; }
        .request-card { border: 1px solid #fbbf24; background: rgba(251, 191, 36, 0.05); }
        .btn-yellow { background: #fbbf24; color: black; border: none; padding: 10px; border-radius: 6px; font-weight: bold; cursor: pointer; width: 100%; }
        .btn-chat { background: #10b981; color: white; text-decoration: none; padding: 10px; border-radius: 6px; display: block; font-weight: bold; }
        .msg-icon { font-size: 24px; text-decoration: none; color: #fbbf24; cursor: pointer; }
        h2 { color: #fbbf24; margin-top: 0; }
    </style>
</head>
<body>
    <div class="header">
        <div style="color:#fbbf24; font-weight:800; font-size: 24px;">ALUMNI NETWORK</div>
        <div>
            <a href="InboxServlet" class="msg-icon" title="Your Messages">✉️</a>
            <a href="alumni_dashboard.jsp" style="color:white; text-decoration:none; margin-left: 20px;">Back to Dashboard</a>
        </div>
    </div>

    <div class="container">
        <% 
            List<Map<String, String>> requests = (List<Map<String, String>>) request.getAttribute("incomingRequests");
            if(requests != null && !requests.isEmpty()) {
        %>
            <h2>Pending Requests</h2>
            <div class="grid" style="margin-bottom: 50px;">
                <% for(Map<String, String> r : requests) { %>
                    <div class="card request-card">
                        <div style="font-size: 2rem; margin-bottom: 10px;">👋</div>
                        <h3><%= r.get("senderName") %></h3>
                        <p>Class of <%= r.get("year") %></p>
                        <form action="NetworkHandler" method="post">
                            <input type="hidden" name="action" value="accept">
                            <input type="hidden" name="connectionId" value="<%= r.get("connectionId") %>">
                            <button type="submit" class="btn-yellow">Accept Request</button>
                        </form>
                    </div>
                <% } %>
            </div>
        <% } %>

        <form class="search-bar" action="NetworkHandler" method="get">
            <input type="text" name="searchQuery" placeholder="Search by name...">
            <input type="text" name="searchYear" placeholder="Graduation Year (e.g. 2019-01-01)">
            <button type="submit" class="btn-yellow" style="width: auto; padding: 0 30px;">Search</button>
        </form>

        <h1 style="margin-bottom: 30px;">Connect with Alumni</h1>
        <div class="grid">
            <% 
                List<Map<String, String>> alumni = (List<Map<String, String>>) request.getAttribute("alumniList");
                if(alumni != null && !alumni.isEmpty()) {
                    for(Map<String, String> a : alumni) {
                        String status = a.get("status");
            %>
                <div class="card">
                    <div style="font-size: 3rem; margin-bottom: 15px;">👤</div>
                    <h3><%= a.get("name") %></h3>
                    <p style="color:#94a3b8;">Class of <%= a.get("year") %></p>
                    
                    <% if("Connect".equals(status)) { %>
                        <form action="NetworkHandler" method="post">
                            <input type="hidden" name="action" value="connect">
                            <input type="hidden" name="receiverId" value="<%= a.get("id") %>">
                            <button type="submit" class="btn-yellow">Connect</button>
                        </form>
                    <% } else if("Accepted".equalsIgnoreCase(status)) { %>
                        <a href="MessageServlet?receiverId=<%= a.get("id") %>" class="btn-chat">Message</a>
                    <% } else { %>
                        <span style="color: #94a3b8;"><%= status %> Request</span>
                    <% } %>
                </div>
            <% } } %>
        </div>
    </div>
</body>
</html>