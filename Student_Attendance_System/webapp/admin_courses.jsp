<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="model.User" %>
        <%@ page import="model.Course" %>
            <%@ page import="java.util.List" %>
                <% // Prevent caching response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
                    response.setHeader("Pragma", "no-cache" ); response.setDateHeader("Expires", 0); User user=(User)
                    session.getAttribute("user"); if (user==null || !"admin".equals(user.getRole())) {
                    response.sendRedirect("login.jsp"); return; } List<Course> courses = (List<Course>)
                        request.getAttribute("courses");
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Admin - Courses & Enrollments</title>
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
                                        <li class="active">
                                            <a href="<%=request.getContextPath()%>/AdminCourseServlet"><i
                                                    class="fa-solid fa-book"></i> Courses & Enrollments</a>
                                        </li>
                                        <li>
                                            <a href="<%=request.getContextPath()%>/AdminCourseServlet"><i
                                                    class="fa-solid fa-calendar-check"></i> Attendance</a>
                                        </li>
                                    </ul>
                                </nav>

                                <!-- Page Content -->
                                <div id="content">
                                    <div class="top-navbar">
                                        <h4 class="mb-0">Courses & Enrollments</h4>
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

                                                    <div class="row">
                                                        <!-- Courses list -->
                                                        <div class="col-lg-8">
                                                            <div class="card card-custom">
                                                                <div
                                                                    class="card-header-custom d-flex justify-content-between align-items-center">
                                                                    <span>All Courses</span>
                                                                    <span class="badge bg-primary rounded-pill">
                                                                        Total: <%= (courses !=null) ? courses.size() : 0
                                                                            %>
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
                                                                                <% if (courses !=null &&
                                                                                    !courses.isEmpty()) { for (Course c
                                                                                    : courses) { %>
                                                                                    <tr>
                                                                                        <td>#<%= c.getCourseId() %>
                                                                                        </td>
                                                                                        <td class="fw-bold">
                                                                                            <%= c.getCourseCode() %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= c.getCourseName() %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <a href="AdminAttendanceServlet?courseId=<%= c.getCourseId() %>"
                                                                                                class="btn btn-sm btn-outline-primary mb-1">
                                                                                                <i
                                                                                                    class="fa-solid fa-calendar-check"></i>
                                                                                                Mark Attendance
                                                                                            </a>
                                                                                            <button
                                                                                                class="btn btn-sm btn-outline-secondary mb-1"
                                                                                                onclick="openEditCourseModal(<%= c.getCourseId() %>, '<%= c.getCourseName().replaceAll("'", "\\\\'") %>', '<%= c.getCourseCode().replaceAll("'", "\\\\'") %>')"
                                                                                                title="Edit Course">
                                                                                                <i
                                                                                                    class="fa-solid fa-edit"></i>
                                                                                                Edit
                                                                                            </button>
                                                                                            <form
                                                                                                action="<%=request.getContextPath()%>/AdminCourseServlet"
                                                                                                method="POST"
                                                                                                class="d-inline"
                                                                                                onsubmit="return confirm('WARNING: Deleting this course will also delete all its enrollments and attendance records! Are you sure?');">
                                                                                                <input type="hidden"
                                                                                                    name="action"
                                                                                                    value="deleteCourse">
                                                                                                <input type="hidden"
                                                                                                    name="courseId"
                                                                                                    value="<%= c.getCourseId() %>">
                                                                                                <button type="submit"
                                                                                                    class="btn btn-sm btn-outline-danger mb-1"
                                                                                                    title="Delete Course">
                                                                                                    <i
                                                                                                        class="fa-solid fa-trash"></i>
                                                                                                    Delete
                                                                                                </button>
                                                                                            </form>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <% } } else { %>
                                                                                        <tr>
                                                                                            <td colspan="4"
                                                                                                class="text-center py-4">
                                                                                                No courses found. Please
                                                                                                add a course.
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
                                                                    <form
                                                                        action="<%=request.getContextPath()%>/AdminCourseServlet"
                                                                        method="POST">
                                                                        <input type="hidden" name="action"
                                                                            value="addCourse">
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label text-muted small fw-bold">Course
                                                                                Name</label>
                                                                            <input type="text" class="form-control"
                                                                                name="courseName" required>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label text-muted small fw-bold">Course
                                                                                Code</label>
                                                                            <input type="text" class="form-control"
                                                                                name="courseCode" required>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label text-muted small fw-bold">Lecture
                                                                                Day</label>
                                                                            <select class="form-select"
                                                                                name="lectureDay" required>
                                                                                <option value="Monday">Monday</option>
                                                                                <option value="Tuesday">Tuesday</option>
                                                                                <option value="Wednesday">Wednesday
                                                                                </option>
                                                                                <option value="Thursday">Thursday
                                                                                </option>
                                                                                <option value="Friday">Friday</option>
                                                                                <option value="Saturday">Saturday
                                                                                </option>
                                                                                <option value="Sunday">Sunday</option>
                                                                            </select>
                                                                        </div>
                                                                        <div class="mb-3">
                                                                            <label
                                                                                class="form-label text-muted small fw-bold">Lecture
                                                                                Time</label>
                                                                            <input type="time" class="form-control"
                                                                                name="lectureTime" required>
                                                                        </div>
                                                                        <button type="submit"
                                                                            class="btn btn-primary w-100">

                                                                            <i class="fa-solid fa-plus"></i> Create
                                                                            Course
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                </div>
                            </div>

                            <!-- Edit Course Modal -->
                            <div class="modal fade" id="editCourseModal" tabindex="-1"
                                aria-labelledby="editCourseModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form action="<%=request.getContextPath()%>/AdminCourseServlet" method="POST">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="editCourseModalLabel">Edit Course</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <input type="hidden" name="action" value="editCourse">
                                                <input type="hidden" name="courseId" id="editCourseId">

                                                <div class="mb-3">
                                                    <label class="form-label text-muted small fw-bold">Course
                                                        Name</label>
                                                    <input type="text" class="form-control" name="courseName"
                                                        id="editCourseName" required>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label text-muted small fw-bold">Course
                                                        Code</label>
                                                    <input type="text" class="form-control" name="courseCode"
                                                        id="editCourseCode" required>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-primary">Save Changes</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                            <script>
                                function openEditCourseModal(id, name, code) {
                                    document.getElementById('editCourseId').value = id;
                                    document.getElementById('editCourseName').value = name;
                                    document.getElementById('editCourseCode').value = code;
                                    var editModal = new bootstrap.Modal(document.getElementById('editCourseModal'));
                                    editModal.show();
                                }
                            </script>
                        </body>

                        </html>