<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Event Management Dashboard</title>
    <style>
        :root {
            --primary-dark: #0d235b;
            --accent-blue: #1e3a8a;
            --danger: #ef4444;
            --success: #10b981;
            --bg-gradient: linear-gradient(135deg, #0d235b 0%, #1e3a8a 100%);
        }

        body { 
            background: var(--bg-gradient);
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 20px;
        }

        .container { 
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 1100px;
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 { 
            color: var(--primary-dark);
            margin-bottom: 30px;
            font-size: 28px;
            border-left: 5px solid var(--accent-blue);
            padding-left: 15px;
        }

        /* Form Styling */
        .form-section {
            background: #f8fafc;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 35px;
            border: 1px solid #e2e8f0;
        }

        .add-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .add-form input, .add-form textarea {
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .add-form input:focus {
            outline: none;
            border-color: var(--accent-blue);
            box-shadow: 0 0 0 3px rgba(30, 58, 138, 0.1);
        }

        .full-width { grid-column: 1 / -1; }

        .btn-submit {
            grid-column: 1 / -1;
            background: var(--primary-dark);
            color: white;
            border: none;
            padding: 14px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-submit:hover { background: #1a367a; }

        /* Table Styling */
        .table-container { overflow-x: auto; }

        table { 
            width: 100%; 
            border-collapse: separate; 
            border-spacing: 0;
            margin-top: 10px;
        }

        th { 
            background: #f1f5f9;
            color: #475569;
            font-weight: 600;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #e2e8f0;
        }

        td { 
            padding: 15px; 
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
            color: #334155;
        }

        tr:hover td { background-color: #fcfcfd; }

        .event-title { color: var(--primary-dark); font-weight: 700; margin-bottom: 4px; display: block; }
        .event-desc { color: #64748b; font-size: 0.85rem; line-height: 1.4; }

        .badge-id {
            background: #e0e7ff;
            color: #4338ca;
            padding: 4px 8px;
            border-radius: 6px;
            font-weight: bold;
            font-size: 12px;
        }

        .btn-delete {
            color: var(--danger);
            background: transparent;
            border: 1px solid var(--danger);
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-delete:hover {
            background: var(--danger);
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #94a3b8;
            font-style: italic;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Event Management</h2>
    
    <div class="form-section">
        <form action="EventHandler" method="POST" class="add-form">
            <input type="hidden" name="action" value="add">
            <input type="text" name="name" placeholder="Event Name" required>
            <input type="date" name="date" required>
            <input type="text" name="loc" placeholder="Location" required>
            <input type="number" name="orgId" placeholder="Organizer ID" required>
            <input type="text" name="desc" placeholder="Brief Description" class="full-width" required>
            <button type="submit" class="btn-submit">Add New Event to Database</button>
        </form>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th style="width: 80px;">ID</th>
                    <th>Event Details</th>
                    <th>Date & Time</th>
                    <th>Location</th>
                    <th style="text-align: center;">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Map<String, String>> events = (List<Map<String, String>>) request.getAttribute("eventList");
                    if (events != null && !events.isEmpty()) {
                        for (Map<String, String> row : events) {
                %>
                <tr>
                    <td><span class="badge-id">#<%= row.get("event_id") %></span></td>
                    <td>
                        <span class="event-title"><%= row.get("event_name") %></span>
                        <span class="event-desc"><%= row.get("event_description") %></span>
                    </td>
                    <td style="white-space: nowrap; font-size: 0.9rem;">
                        <strong>📅 <%= row.get("event_date").split(" ")[0] %></strong><br>
                        <small style="color: #94a3b8;">🕒 <%= row.get("event_date").split(" ").length > 1 ? row.get("event_date").split(" ")[1] : "00:00:00" %></small>
                    </td>
                    <td>📍 <%= row.get("event_location") %></td>
                    <td style="text-align: center;">
                        <form action="EventHandler" method="POST" onsubmit="return confirm('Are you sure you want to delete this event?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= row.get("event_id") %>">
                            <button type="submit" class="btn-delete">Delete</button>
                        </form>
                    </td>
                </tr>
                <% 
                        } 
                    } else { 
                %>
                <tr>
                    <td colspan="5" class="empty-state">
                        <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" width="50" style="opacity: 0.2; margin-bottom: 10px;"><br>
                        No records found in the database.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>