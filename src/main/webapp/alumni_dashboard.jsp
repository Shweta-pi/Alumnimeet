<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Fix: Using a safe check to prevent the "String casting" error you reported
    Object roleObj = session.getAttribute("role");
    String role = (roleObj != null) ? roleObj.toString() : "";
    String fname = (String) session.getAttribute("fname");

    // Security Check: Redirect if not logged in as alumni
    if(fname == null || !"alumni".equalsIgnoreCase(role)) {
        response.sendRedirect("login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Alumni Dashboard | AlumniMeet</title>
    <style>
        :root {
            --bg-deep: #020617;
            --glass: rgba(30, 41, 59, 0.7);
            --accent-gold: #fbbf24; 
            --silver-text: #94a3b8;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-deep);
            margin: 0; color: #f8fafc;
        }

        .navbar { 
            background: rgba(15, 23, 42, 0.9);
            padding: 15px 50px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            border-bottom: 2px solid var(--accent-gold);
        }

        .logo { font-weight: 800; color: var(--accent-gold); letter-spacing: 1px; }

        .dashboard-container { padding: 40px; display: flex; flex-direction: column; align-items: center; }

        .dashboard-card { 
            background: var(--glass);
            border-radius: 20px; padding: 40px; 
            width: 100%; max-width: 1100px; 
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
            border: 1px solid rgba(255,255,255,0.05);
        }

        .action-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); 
            gap: 25px; 
            margin-top: 30px;
        }

        .card { 
            background: rgba(15, 23, 42, 0.6); 
            padding: 30px; border-radius: 12px;
            border: 1px solid rgba(251, 191, 36, 0.1);
            text-align: center; transition: 0.3s ease;
            text-decoration: none; color: inherit;
            display: block;
        }

        .card:hover { 
            border-color: var(--accent-gold);
            transform: translateY(-5px);
            background: rgba(15, 23, 42, 0.9);
        }

        .icon { font-size: 2.5rem; margin-bottom: 15px; display: block; }
        .badge { background: var(--accent-gold); color: #000; padding: 4px 12px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="logo">ALUMNIMEET</div>
        <a href="LogoutHandler" style="color: #ef4444; text-decoration: none; font-weight: 600;">LOGOUT</a>
    </nav>

    <div class="dashboard-container">
        <div class="dashboard-card">
            <span class="badge">Alumni Member</span>
            <h1 style="margin-top: 15px;">Welcome, <%= fname %></h1>
            <p style="color: var(--silver-text);">Connect with your batchmates and discover new opportunities.</p>

            <div class="action-grid">
                <a href="NetworkHandler" class="card">
                    <span class="icon">🌐</span>
                    <h3>Alumni Network</h3>
                    <p>Find and connect with your university batchmates.</p>
                </a>

                <a href="events.jsp" class="card">
                    <span class="icon">📅</span>
                    <h3>Upcoming Events</h3>
                    <p>View and RSVP for campus meetups and webinars.</p>
                </a>

                <a href="jobs.jsp" class="card">
                    <span class="icon">💼</span>
                    <h3>Job Board</h3>
                    <p>Explore career opportunities posted by fellow alumni.</p>
                </a>

                <a href="profile.jsp" class="card">
                    <span class="icon">👤</span>
                    <h3>My Profile</h3>
                    <p>Update your professional details and location.</p>
                </a>
            </div>
        </div>
    </div>

</body>
</html>