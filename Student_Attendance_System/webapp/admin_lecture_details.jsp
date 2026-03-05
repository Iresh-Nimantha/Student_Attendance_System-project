<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.AttendanceDetail" %>
<%@ page import="model.User" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<AttendanceDetail> lectureDetails = (List<AttendanceDetail>) request.getAttribute("lectureDetails");
    Integer courseId = (Integer) request.getAttribute("courseId");
    String lectureDate = (String) request.getAttribute("lectureDate");
    String lectureTime = (String) request.getAttribute("lectureTime");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lecture Details - Smart Attendance</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f4f6f9;
            overflow-x: hidden;
        }
        .wrapper {
            display: flex;
            width: 100%;
            align-items: stretch;
        }
        #sidebar {
            min-width: 250px;
            max-width: 250px;
            background: #2c3e50;
            color: #fff;
            min-height: 100vh;
        }
        #sidebar .sidebar-header {
            padding: 20px;
            background: #1a252f;
        }
        #sidebar ul.components {
            padding: 20px 0;
        }
        #sidebar ul li a {
            padding: 10px 20px;
            font-size: 1.1em;
            display: block;
            color: #ecf0f1;
            text-decoration: none;
            transition: 0.3s;
        }
        #sidebar ul li a:hover,
        #sidebar ul li.active>a {
            color: #3498db;
            background: #fff;
        }
        #sidebar ul li a i {
            margin-right: 10px;
        }
        #content {
            width: 100%;
            padding: 20px;
            min-height: 100vh;
        }
        .top-navbar {
            background: #fff;
            padding: 15px 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-custom {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }
        .card-header-custom {
            background-color: #fff;
            border-bottom: 1px solid #f0f0f0;
            padding: 15px 20px;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            font-weight: 600;
        }
        @media (max-width: 768px) {
            .wrapper {
                flex-direction: column;
            }
            #sidebar {
                min-width: 100%;
                max-width: 100%;
                min-height: auto;
            }
        }
    </style>
</head>
<body>
<div class="wrapper">
    <nav id="sidebar">
        <div class="sidebar-header">
            <h3><i class="fa-solid fa-graduation-cap"></i> Admin Panel</h3>
        </div>
        <ul class="list-unstyled components">
            <li>
                <a href="<%=request.getContextPath()%>/AdminServlet"><i class="fa-solid fa-users"></i> Users</a>
            </li>
            <li class="active">
                <a href="<%=request.getContextPath()%>/AdminCourseServlet"><i class="fa-solid fa-book"></i> Courses & Enrollments</a>
            </li>
            <li>
                <a href="<%=request.getContextPath()%>/AdminCourseServlet"><i class="fa-solid fa-calendar-check"></i> Attendance</a>
            </li>
        </ul>
    </nav>

    <div id="content">
        <div class="top-navbar">
            <h4 class="mb-0">
                Lecture Attendance Details
                <% if (lectureDate != null && !lectureDate.isEmpty()) { %>
                    - <span class="text-primary"><%= lectureDate %></span>
                <% } %>
                <% if (lectureTime != null && !lectureTime.isEmpty()) { %>
                    <span class="text-muted">@ <%= lectureTime %></span>
                <% } %>
            </h4>
            <div>
                <span class="me-3 fw-bold">
                    <i class="fa-solid fa-user-shield text-primary"></i> <%= user.getName() %>
                </span>
                <a href="LoginServlet?action=logout" class="btn btn-sm btn-outline-danger">Logout</a>
            </div>
        </div>

        <div class="mb-3">
            <a href="AdminAttendanceServlet?courseId=<%= courseId != null ? courseId : 0 %>" class="btn btn-outline-secondary">
                <i class="fa-solid fa-arrow-left"></i> Back to Attendance
            </a>
        </div>

        <div class="card card-custom">
            <div class="card-header-custom d-flex justify-content-between align-items-center">
                <span>Students for this Lecture</span>
                <span class="badge bg-primary rounded-pill">
                    <% out.print(lectureDetails != null ? lectureDetails.size() : 0); %> student(s)
                </span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (lectureDetails != null && !lectureDetails.isEmpty()) {
                               for (AttendanceDetail d : lectureDetails) { %>
                            <tr>
                                <td>#<%= d.getStudentId() %></td>
                                <td class="fw-bold"><%= d.getStudentName() %></td>
                                <td><%= d.getStudentEmail() %></td>
                                <td>
                                    <% String status = d.getStatus(); %>
                                    <% if ("present".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-success"><i class="fa-solid fa-user-check me-1"></i>Present</span>
                                    <% } else if ("absent".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-danger"><i class="fa-solid fa-user-xmark me-1"></i>Absent</span>
                                    <% } else if ("late".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-warning text-dark"><i class="fa-solid fa-user-clock me-1"></i>Late</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary text-light"><%= status %></span>
                                    <% } %>
                                </td>
                            </tr>
                        <%   }
                           } else { %>
                            <tr>
                                <td colspan="4" class="text-center py-4 text-muted">
                                    No attendance records found for this lecture.
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

