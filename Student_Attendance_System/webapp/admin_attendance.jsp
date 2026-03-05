<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="model.User" %>
        <%@ page import="model.Course" %>
            <%@ page import="java.util.List" %>
                <% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
                    response.setHeader("Pragma", "no-cache" ); response.setDateHeader("Expires", 0); User user=(User)
                    session.getAttribute("user"); if (user==null || !"admin".equals(user.getRole())) {
                    response.sendRedirect("login.jsp"); return; } Course course=(Course) request.getAttribute("course");
                    List<User> students = (List<User>) request.getAttribute("students");
                        Integer courseId = (Integer) request.getAttribute("courseId");
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Mark Attendance - Smart Attendance</title>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link
                                href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                                rel="stylesheet">
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

                                .attendance-summary-card {
                                    border-left: 4px solid #3498db;
                                }

                                #sidebar {
                                    min-width: 250px;
                                    max-width: 250px;
                                    background: #2c3e50;
                                    color: #fff;
                                    transition: all 0.3s;
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
                                    transition: all 0.3s;
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
                                <!-- Sidebar -->
                                <nav id="sidebar">
                                    <div class="sidebar-header">
                                        <h3><i class="fa-solid fa-graduation-cap"></i> Admin Panel</h3>
                                    </div>
                                    <ul class="list-unstyled components">
                                        <li>
                                            <a href="<%=request.getContextPath()%>/AdminServlet"><i
                                                    class="fa-solid fa-users"></i> Users</a>
                                        </li>
                                        <li>
                                            <a href="<%=request.getContextPath()%>/AdminCourseServlet"><i
                                                    class="fa-solid fa-book"></i> Courses & Enrollments</a>
                                        </li>
                                        <li class="active">
                                            <a href="#"><i class="fa-solid fa-calendar-check"></i> Attendance</a>
                                        </li>
                                    </ul>
                                </nav>

                                <!-- Page Content -->
                                <div id="content">
                                    <div class="top-navbar">
                                        <h4 class="mb-0">
                                            Mark Attendance
                                            <% if (course !=null) { %>
                                                - <span class="text-primary">
                                                    <%= course.getCourseCode() %> - <%= course.getCourseName() %>
                                                </span>
                                                <% } %>
                                        </h4>
                                        <div>
                                            <span class="me-3 fw-bold"><i
                                                    class="fa-solid fa-user-shield text-primary"></i>
                                                <%= user.getName() %>
                                            </span>
                                            <a href="LoginServlet?action=logout"
                                                class="btn btn-sm btn-outline-danger">Logout</a>
                                        </div>
                                    </div>

                                    <% if (request.getParameter("success") !=null) { %>
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            <%= request.getParameter("success") %>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="alert"></button>
                                        </div>
                                        <% } %>
                                            <% if (request.getParameter("error") !=null) { %>
                                                <div class="alert alert-danger alert-dismissible fade show"
                                                    role="alert">
                                                    <%= request.getParameter("error") %>
                                                        <button type="button" class="btn-close"
                                                            data-bs-dismiss="alert"></button>
                                                </div>
                                                <% } %>

                                                    <div class="card card-custom">
                                                        <div class="card-header-custom">
                                                            Lecture Details
                                                        </div>
                                                        <div class="card-body">
                                                            <form
                                                                action="<%=request.getContextPath()%>/AdminAttendanceServlet"
                                                                method="POST">
                                                                <input type="hidden" name="courseId"
                                                                    value="<%= courseId != null ? courseId : 0 %>">

                                                                <div class="row mb-3">
                                                                    <div class="col-md-4">
                                                                        <label
                                                                            class="form-label text-muted small fw-bold">Lecture
                                                                            Day/Date</label>
                                                                        <input type="text" class="form-control"
                                                                            name="lectureDate"
                                                                            placeholder="e.g. Monday or 01-Jan"
                                                                            value="${defaultLectureDay}" required>
                                                                    </div>
                                                                    <div class="col-md-4">
                                                                        <label
                                                                            class="form-label text-muted small fw-bold">Lecture
                                                                            Time</label>
                                                                        <input type="time" class="form-control"
                                                                            name="lectureTime"
                                                                            value="${defaultLectureTime}" required>
                                                                    </div>
                                                                </div>

                                                                <div class="table-responsive mt-4">
                                                                    <table class="table table-hover mb-0">
                                                                        <thead class="table-light">
                                                                            <tr>
                                                                                <th>Student</th>
                                                                                <th>Email</th>
                                                                                <th>Status</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <% if (students !=null &&
                                                                                !students.isEmpty()) { for (User s :
                                                                                students) { %>
                                                                                <tr>
                                                                                    <td class="fw-bold">
                                                                                        <%= s.getName() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= s.getEmail() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <select
                                                                                            name="status_<%= s.getId() %>"
                                                                                            class="form-select">
                                                                                            <option value="present"
                                                                                                selected>Present
                                                                                            </option>
                                                                                            <option value="absent">
                                                                                                Absent</option>
                                                                                            <option value="late">Late
                                                                                            </option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                                <% } } else { %>
                                                                                    <tr>
                                                                                        <td colspan="3"
                                                                                            class="text-center py-4">
                                                                                            No students enrolled in this
                                                                                            course yet.
                                                                                        </td>
                                                                                    </tr>
                                                                                    <% } %>
                                                                        </tbody>
                                                                    </table>
                                                                </div>

                                                                <div class="mt-4 text-end">
                                                                    <a href="AdminCourseServlet"
                                                                        class="btn btn-outline-secondary me-2">
                                                                        <i class="fa-solid fa-arrow-left"></i> Back to
                                                                        Courses
                                                                    </a>
                                                                    <button type="submit" class="btn btn-primary">
                                                                        <i class="fa-solid fa-check"></i> Save
                                                                        Attendance
                                                                    </button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>

                                                    <!-- Past Lectures Summary -->
                                                    <div class="card card-custom mt-4 attendance-summary-card">
                                                        <div
                                                            class="card-header-custom d-flex justify-content-between align-items-center">
                                                            <span>Past Lectures Summary</span>
                                                            <span class="badge bg-secondary rounded-pill">
                                                                <%
                                                                    java.util.List<model.LectureRecord> pastLectures =
                                                                        (java.util.List<model.LectureRecord>) request.getAttribute("pastLectures");
                                                                    out.print(pastLectures != null ? pastLectures.size() : "0");
                                                                %> Session(s)
                                                            </span>
                                                        </div>
                                                        <div class="card-body p-0">
                                                            <div class="table-responsive">
                                                                <table class="table table-hover mb-0">
                                                                    <thead class="table-light">
                                                                        <tr>
                                                                            <th>Lecture Date</th>
                                                                            <th>Time</th>
                                                                            <th class="text-success">
                                                                                <i class="fa-solid fa-user-check"></i>
                                                                                Present
                                                                            </th>
                                                                            <th class="text-danger">
                                                                                <i class="fa-solid fa-user-xmark"></i>
                                                                                Absent
                                                                            </th>
                                                                            <th class="text-warning">
                                                                                <i class="fa-solid fa-user-clock"></i>
                                                                                Late
                                                                            </th>
                                                                            <th>Details</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <%
                                                                            if (pastLectures != null && !pastLectures.isEmpty()) {
                                                                                for (model.LectureRecord lr : pastLectures) {
                                                                        %>
                                                                            <tr>
                                                                                <td class="fw-bold">
                                                                                    <%= lr.getLectureDate() %>
                                                                                </td>
                                                                                <td class="text-muted">
                                                                                    <%= lr.getLectureTime() != null ? lr.getLectureTime() : "N/A" %>
                                                                                </td>
                                                                                <td>
                                                                                    <span class="badge bg-success">
                                                                                        <%= lr.getPresentCount() %>
                                                                                    </span>
                                                                                </td>
                                                                                <td>
                                                                                    <span class="badge bg-danger">
                                                                                        <%= lr.getAbsentCount() %>
                                                                                    </span>
                                                                                </td>
                                                                                <td>
                                                                                    <span class="badge bg-warning text-dark">
                                                                                        <%= lr.getLateCount() %>
                                                                                    </span>
                                                                                </td>
                                                                                <td>
                                                                                    <a
                                                                                        href="AdminLectureDetailsServlet?lectureId=<%= lr.getLectureId() %>&courseId=<%= courseId != null ? courseId : 0 %>&lectureDate=<%= lr.getLectureDate() %>&lectureTime=<%= lr.getLectureTime() != null ? lr.getLectureTime().toString() : "" %>"
                                                                                        class="btn btn-sm btn-outline-secondary">
                                                                                        <i class="fa-solid fa-list"></i>
                                                                                        View Students
                                                                                    </a>
                                                                                </td>
                                                                            </tr>
                                                                        <%
                                                                                }
                                                                            } else {
                                                                        %>
                                                                            <tr>
                                                                                <td colspan="6"
                                                                                    class="text-center py-4 text-muted">
                                                                                    No past attendance records found
                                                                                    for this course.
                                                                                </td>
                                                                            </tr>
                                                                        <%
                                                                            }
                                                                        %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                </div>
                            </div>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        </body>

                        </html>