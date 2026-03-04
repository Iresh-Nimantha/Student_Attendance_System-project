<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="java.util.List" %>
<%
    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Courses & Enrollments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f4f6f9;
            overflow-x: hidden;
        }
        .wrapper { display: flex; width: 100%; align-items: stretch; }
        #sidebar {
            min-width: 250px; max-width: 250px;
            background: #2c3e50; color: #fff;
            transition: all 0.3s; min-height: 100vh;
        }
        #sidebar .sidebar-header { padding: 20px; background: #1a252f; }
        #sidebar ul.components { padding: 20px 0; }
        #sidebar ul li a {
            padding: 10px 20px; font-size: 1.1em;
            display: block; color: #ecf0f1;
            text-decoration: none; transition: 0.3s;
        }
        #sidebar ul li a:hover, #sidebar ul li.active > a {
            color: #3498db; background: #fff;
        }
        #sidebar ul li a i { margin-right: 10px; }
        #content { width: 100%; padding: 20px; min-height: 100vh; transition: all 0.3s; }
        .top-navbar {
            background: #fff; padding: 15px 20px; border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center;
        }
        .card-custom {
            border: none; border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        .card-header-custom {
            background-color: #fff; border-bottom: 1px solid #f0f0f0;
            padding: 15px 20px; border-top-left-radius: 15px;
            border-top-right-radius: 15px; font-weight: 600;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <!-- Sidebar -->
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

    <!-- Page Content -->
    <div id="content">
        <div class="top-navbar">
            <h4 class="mb-0">Courses & Enrollments</h4>
            <div>
                <span class="me-3 fw-bold"><i class="fa-solid fa-user-shield text-primary"></i> <%= user.getName() %></span>
                <a href="LoginServlet?action=logout" class="btn btn-sm btn-outline-danger">Logout</a>
            </div>
        </div>

        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= request.getParameter("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row">
            <!-- Courses list -->
            <div class="col-lg-8">
                <div class="card card-custom">
                    <div class="card-header-custom d-flex justify-content-between align-items-center">
                        <span>All Courses</span>
                        <span class="badge bg-primary rounded-pill">
                            Total: <%= (courses != null) ? courses.size() : 0 %>
                        </span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% if (courses != null && !courses.isEmpty()) {
                                       for (Course c : courses) { %>
                                    <tr>
                                        <td>#<%= c.getCourseId() %></td>
                                        <td class="fw-bold"><%= c.getCourseCode() %></td>
                                        <td><%= c.getCourseName() %></td>
                                        <td>
                                            <a href="AdminAttendanceServlet?courseId=<%= c.getCourseId() %>"
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="fa-solid fa-calendar-check"></i> Mark Attendance
                                            </a>
                                        </td>
                                    </tr>
                                <%   }
                                   } else { %>
                                    <tr>
                                        <td colspan="4" class="text-center py-4">
                                            No courses found. Please add a course.
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Add course form -->
            <div class="col-lg-4">
                <div class="card card-custom">
                    <div class="card-header-custom">
                        Add New Course
                    </div>
                    <div class="card-body">
                        <form action="<%=request.getContextPath()%>/AdminCourseServlet" method="POST">
                            <input type="hidden" name="action" value="addCourse">
                            <div class="mb-3">
                                <label class="form-label text-muted small fw-bold">Course Name</label>
                                <input type="text" class="form-control" name="courseName" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-muted small fw-bold">Course Code</label>
                                <input type="text" class="form-control" name="courseCode" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fa-solid fa-plus"></i> Create Course
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

