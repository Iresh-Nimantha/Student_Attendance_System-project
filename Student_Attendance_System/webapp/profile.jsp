<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="model.User" %>
        <%@ page import="model.Course" %>
            <%@ page import="java.util.List" %>
                <% // Prevent caching to guarantee redirect on back button after logout
                    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
                    response.setHeader("Pragma", "no-cache" ); response.setDateHeader("Expires", 0); User user=(User)
                    session.getAttribute("user"); if (user==null || !"student".equals(user.getRole())) {
                    response.sendRedirect("login.jsp"); return; } %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Student Profile - Smart Attendance</title>
                        <!-- Bootstrap CSS -->
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link
                            href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                            rel="stylesheet">
                        <style>
                            body {
                                font-family: 'Inter', sans-serif;
                                background-color: #f8f9fa;
                            }

                            .navbar-custom {
                                background-color: #2c3e50;
                                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                            }

                            .navbar-custom .navbar-brand,
                            .navbar-custom .nav-link {
                                color: #fff;
                            }

                            .profile-header {
                                background: linear-gradient(135deg, #3498db, #8e44ad);
                                color: white;
                                padding: 3rem 0;
                                margin-bottom: 2rem;
                                border-bottom-left-radius: 20px;
                                border-bottom-right-radius: 20px;
                                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.05);
                            }

                            .card-custom {
                                border: none;
                                border-radius: 15px;
                                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                                transition: transform 0.2s;
                                margin-bottom: 1.5rem;
                            }

                            .card-custom:hover {
                                transform: translateY(-5px);
                            }

                            .card-title {
                                font-weight: 600;
                                color: #2c3e50;
                                border-bottom: 2px solid #f1f2f6;
                                padding-bottom: 10px;
                                margin-bottom: 15px;
                            }

                            .btn-enroll {
                                background-color: #2ecc71;
                                color: white;
                                border-radius: 20px;
                                padding: 8px 20px;
                            }

                            .btn-enroll:hover {
                                background-color: #27ae60;
                                color: white;
                            }
                        </style>
                    </head>

                    <body>

                        <!-- Navigation -->
                        <nav class="navbar navbar-expand-lg navbar-custom">
                            <div class="container">
                                <a class="navbar-brand fw-bold" href="#">Smart Attendance</a>
                                <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#navbarNav">
                                    <span class="navbar-toggler-icon" style="filter: invert(1);"></span>
                                </button>
                                <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                                    <ul class="navbar-nav">
                                        <li class="nav-item">
                                            <a class="nav-link" href="#">Profile</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link text-danger" href="LoginServlet?action=logout">Logout</a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </nav>

                        <!-- Profile Header -->
                        <div class="profile-header text-center">
                            <div class="container">
                                <h1 class="display-4 fw-bold">Welcome, <%= user.getName() %>!</h1>
                                <p class="lead mb-0">
                                    <%= user.getEmail() %>
                                </p>
                            </div>
                        </div>

                        <!-- Main Content -->
                        <div class="container">

                            <% if (request.getParameter("success") !=null) { %>
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <%= request.getParameter("success") %>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% } %>
                                    <% if (request.getParameter("error") !=null) { %>
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <%= request.getParameter("error") %>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="alert"></button>
                                        </div>
                                        <% } %>

                                            <div class="row">
                                                <!-- Left Column: Courses to Enroll -->
                                                <div class="col-md-6">
                                                    <div class="card card-custom p-4">
                                                        <h4 class="card-title">Available Courses</h4>

                                                        <form action="<%=request.getContextPath()%>/CourseServlet"
                                                            method="POST">
                                                            <div class="mb-3">
                                                                <label for="courseSelect"
                                                                    class="form-label text-muted">Select a course to
                                                                    enroll:</label>
                                                                <select class="form-select" id="courseSelect"
                                                                    name="courseId" required>
                                                                    <option value="" disabled selected>-- Choose Course
                                                                        --</option>
                                                                    <% List<Course> allCourses = (List<Course>)
                                                                            request.getAttribute("allCourses");
                                                                            if(allCourses != null &&
                                                                            !allCourses.isEmpty()) {
                                                                            for(Course c : allCourses) {
                                                                            %>
                                                                            <option value="<%= c.getCourseId() %>">
                                                                                <%= c.getCourseCode() %> - <%=
                                                                                        c.getCourseName() %>
                                                                            </option>
                                                                            <% } } else { %>
                                                                                <option value="" disabled>No courses
                                                                                    available</option>
                                                                                <% } %>
                                                                </select>
                                                            </div>
                                                            <button type="submit" class="btn btn-enroll w-100">Enroll
                                                                Course</button>
                                                        </form>
                                                    </div>
                                                </div>

                                                <!-- Right Column: Enrolled Courses -->
                                                <div class="col-md-6">
                                                    <div class="card card-custom p-4">
                                                        <h4 class="card-title">My Enrolled Courses</h4>
                                                        <ul class="list-group list-group-flush mt-2">
                                                            <% List<Course> enrolledCourses = (List<Course>)
                                                                    request.getAttribute("enrolledCourses");
                                                                    if(enrolledCourses != null &&
                                                                    !enrolledCourses.isEmpty()) {
                                                                    for(Course c : enrolledCourses) {
                                                                    %>
                                                                    <li
                                                                        class="list-group-item d-flex justify-content-between align-items-center">
                                                                        <div>
                                                                            <h6 class="mb-0 fw-bold">
                                                                                <%= c.getCourseName() %>
                                                                            </h6>
                                                                            <small class="text-muted">
                                                                                <%= c.getCourseCode() %>
                                                                            </small>
                                                                        </div>
                                                                        <span
                                                                            class="badge bg-primary rounded-pill">Enrolled</span>
                                                                    </li>
                                                                    <% } } else { %>
                                                                        <li class="list-group-item text-muted">You are
                                                                            not enrolled in any courses yet.</li>
                                                                        <% } %>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    </body>

                    </html>