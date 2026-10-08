<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security check: Redirect to login if session is empty
    if (session.getAttribute("fname") == null) {
        response.sendRedirect("login.html");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Portal</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /* Using a dark blue gradient consistent with your theme */
            background: linear-gradient(rgba(13, 35, 91, 0.8), rgba(13, 35, 91, 0.9)), 
                        url('Gemini_Generated_Image_e5jefie5jefie5je.png'); 
            background-size: cover;
            background-attachment: fixed;
            margin: 0;
            color: #fff;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .navbar {
            background: rgba(13, 35, 91, 1);
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }

        .navbar h2 { margin: 0; font-size: 1.5rem; letter-spacing: 1px; }

        .btn-logout {
            color: #ff4d4d;
            text-decoration: none;
            font-weight: bold;
            text-transform: uppercase;
            border: 2px solid #ff4d4d;
            padding: 5px 15px;
            border-radius: 5px;
            transition: 0.3s;
        }

        .btn-logout:hover {
            background: #ff4d4d;
            color: white;
        }

        .dashboard-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 50px 20px;
        }

        .main-card {
            background: rgba(255, 255, 255, 0.98);
            color: #333;
            border-radius: 15px;
            padding: 40px;
            width: 100%;
            max-width: 900px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
        }

        .role-badge {
            background: #6395c9;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 15px;
        }

        h1 { color: #0d235b; margin-bottom: 30px; border-bottom: 2px solid #eee; padding-bottom: 10px; }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 25px;
        }

        .feature-item {
            padding: 25px;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .feature-item:hover {
            transform: translateY(-5px);
            border-color: #0d235b;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            background-color: #f8faff;
        }

        .feature-item h3 { color: #0d235b; margin-top: 0; }
        .feature-item p { color: #666; font-size: 0.9rem; margin-bottom: 0; }
    </style>
</head>
<body>

    <div class="navbar">
        <h2>STUDENT PORTAL</h2>
        <a href="LogoutHandler" class="btn-logout">Logout</a>
    </div>

    <div class="dashboard-container">
        <div class="main-card">
            <span class="role-badge">Current Student</span>
            <h1>Hello, <%= session.getAttribute("fname") %></h1>

            <div class="feature-grid">
                <div class="feature-item">
                    <h3>Mentorship</h3>
                    <p>Connect with experienced alumni for guidance.</p>
                </div>
                <div class="feature-item">
                    <h3>Events</h3>
                    <p>View upcoming campus meets and seminars.</p>
                </div>
                <div class="feature-item">
                    <h3>Resources</h3>
                    <p>Download study materials and placement papers.</p>
                </div>
                <div class="feature-item">
                    <h3>Placement</h3>
                    <p>Track your job applications and internships.</p>
                </div>
            </div>
        </div>
    </div>

</body>
</html>