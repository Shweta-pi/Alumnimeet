<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Messages | AlumniMeet</title>
    <style>
        body { background: #020617; color: white; font-family: 'Inter', sans-serif; margin: 0; display: flex; height: 100vh; }
        .sidebar { width: 300px; background: #0f172a; border-right: 1px solid #1e293b; padding: 20px; }
        .chat-area { flex: 1; display: flex; flex-direction: column; background: #020617; }
        .contact-item { padding: 15px; border-radius: 8px; margin-bottom: 10px; cursor: pointer; background: rgba(251, 191, 36, 0.05); border: 1px solid transparent; }
        .contact-item:hover { border-color: #fbbf24; }
        .msg-container { flex: 1; padding: 30px; overflow-y: auto; display: flex; flex-direction: column; gap: 10px; }
        .bubble { max-width: 60%; padding: 12px 18px; border-radius: 15px; font-size: 14px; }
        .sent { align-self: flex-end; background: #fbbf24; color: black; }
        .received { align-self: flex-start; background: #1e293b; color: white; }
        .input-box { padding: 20px; background: #0f172a; border-top: 1px solid #1e293b; display: flex; gap: 10px; }
        input { flex: 1; background: #1e293b; border: 1px solid #334155; color: white; padding: 12px; border-radius: 8px; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2 style="color: #fbbf24;">Contacts</h2>
        <% 
            List<Map<String, String>> contacts = (List<Map<String, String>>) request.getAttribute("contacts");
            if(contacts != null) {
                for(Map<String, String> c : contacts) {
        %>
            <a href="MessageServlet?receiverId=<%= c.get("id") %>" style="text-decoration:none; color:inherit;">
                <div class="contact-item">👤 <%= c.get("name") %></div>
            </a>
        <% } } %>
    </div>

    <div class="chat-area">
        <div class="msg-container">
            <% 
                List<Map<String, String>> msgs = (List<Map<String, String>>) request.getAttribute("chatHistory");
                String myId = String.valueOf(session.getAttribute("userId"));
                if(msgs != null) {
                    for(Map<String, String> m : msgs) {
                        boolean isMe = m.get("senderId").equals(myId);
            %>
                <div class="bubble <%= isMe ? "sent" : "received" %>">
                    <%= m.get("content") %>
                </div>
            <% } } else { %>
                <p style="text-align: center; color: #94a3b8; margin-top: 50px;">Select a contact to start chatting</p>
            <% } %>
        </div>

        <% if(request.getParameter("receiverId") != null) { %>
        <form class="input-box" action="MessageServlet" method="post">
            <input type="hidden" name="receiverId" value="<%= request.getParameter("receiverId") %>">
            <input type="text" name="message_content" placeholder="Type a message..." required>
            <button type="submit" style="background: #fbbf24; border: none; padding: 0 20px; border-radius: 8px; font-weight: bold; cursor: pointer;">Send</button>
        </form>
        <% } %>
    </div>
</body>
</html>