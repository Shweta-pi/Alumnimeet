<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session security check
    if(session.getAttribute("fname") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | University Portal</title>
    <style>
        :root {
            --bg-dark: #020617;
            --card-glass: rgba(30, 41, 59, 0.6);
            --accent-blue: #38bdf8;
            --accent-glow: rgba(56, 189, 248, 0.3);
            --text-silver: #cbd5e1;
        }

        body {
            font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
            background: radial-gradient(circle at top right, #1e293b, #020617);
            background-attachment: fixed;
            margin: 0;
            color: #f8fafc;
            min-height: 100vh;
            overflow-x: hidden;
        }

        .navbar { 
            background: rgba(15, 23, 42, 0.8);
            backdrop-filter: blur(12px);
            padding: 15px 50px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo { font-size: 1.2rem; font-weight: 800; letter-spacing: 2px; color: var(--accent-blue); text-transform: uppercase; }
        .btn-logout { color: #f87171; text-decoration: none; font-weight: 600; font-size: 0.9rem; border: 1px solid #f87171; padding: 8px 20px; border-radius: 8px; transition: 0.3s; }
        .btn-logout:hover { background: #f87171; color: white; box-shadow: 0 0 15px rgba(248, 113, 113, 0.4); }

        .dashboard-container { display: flex; justify-content: center; padding: 60px 20px; animation: fadeIn 0.8s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .main-card { background: var(--card-glass); backdrop-filter: blur(15px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 24px; padding: 50px; width: 100%; max-width: 1100px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); }
        .role-badge { background: rgba(56, 189, 248, 0.1); color: var(--accent-blue); padding: 6px 16px; border-radius: 30px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; border: 1px solid var(--accent-blue); margin-bottom: 20px; display: inline-block; }

        h1 { font-size: 2.5rem; font-weight: 300; margin: 10px 0 40px 0; color: #fff; }
        h1 span { font-weight: 800; color: var(--accent-blue); }

        .feature-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 25px; }
        .feature-item { background: rgba(15, 23, 42, 0.4); padding: 35px 25px; border: 1px solid rgba(255, 255, 255, 0.05); border-radius: 20px; transition: all 0.4s; text-align: center; }
        .feature-item:hover { transform: translateY(-10px); border-color: var(--accent-blue); background-color: rgba(30, 41, 59, 0.8); box-shadow: 0 0 15px var(--accent-glow); }

        .feature-item h3 { color: #fff; margin-bottom: 12px; }
        .feature-item p { color: var(--text-silver); font-size: 0.9rem; line-height: 1.5; }
        a { text-decoration: none; display: block; }

        .footer-status { margin-top: 40px; padding-top: 20px; border-top: 1px solid rgba(255, 255, 255, 0.05); font-size: 0.8rem; color: #64748b; display: flex; justify-content: space-between; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="logo">University Portal</div>
        <a href="LogoutHandler" class="btn-logout">LOGOUT</a>
    </nav>

    <div class="dashboard-container">
        <div class="main-card">
            <span class="role-badge">Administrator Access</span>
            <h1>Welcome back, <span><%= session.getAttribute("fname") %></span></h1>

            <div class="feature-grid">
                <a href="AlumniHandler">
                    <div class="feature-item">
                        <div style="font-size: 2rem; margin-bottom: 15px;">🎓</div>
                        <h3>Manage Alumni</h3>
                        <p>Verify records and maintain the global alumni directory.</p>
                    </div>
                </a>

                <a href="StudentHandler">
                    <div class="feature-item">
                        <div style="font-size: 2rem; margin-bottom: 15px;">👥</div>
                        <h3>Manage Students</h3>
                        <p>Track current enrollments and student profile data.</p>
                    </div>
                </a>

                <a href="EventHandler">
                    <div class="feature-item">
                        <div style="font-size: 2rem; margin-bottom: 15px;">📅</div>
                        <h3>Event Calendar</h3>
                        <p>Coordinate meetups, workshops, and campus events.</p>
                    </div>
                </a>
            </div>

            <div class="footer-status">
                <span>Database Status: <span style="color: #10b981;">● Connected</span></span>
                <span>Portal Version 3.0</span>
            </div>
        </div>
    </div>
</body>
</html>