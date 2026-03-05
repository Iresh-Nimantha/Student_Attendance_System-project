<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="model.User" %>
        <%@ page import="java.util.List" %>
            <% // Prevent caching response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
                response.setHeader("Pragma", "no-cache" ); response.setDateHeader("Expires", 0); User user=(User)
                session.getAttribute("user"); if (user==null || !"admin".equals(user.getRole())) {
                response.sendRedirect("login.jsp"); return; } %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Admin Dashboard - Smart Attendance</title>
                    <!-- Bootstrap CSS -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <!-- FontAwesome -->
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

                        /* Sidebar styling */
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

                        #sidebar ul p {
                            color: #fff;
                            padding: 10px;
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

                        /* Content styling */
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

                        .table> :not(caption)>*>* {
                            padding: 1rem 1rem;
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
                                <li class="active">
                                    <a href="<%=request.getContextPath()%>/AdminServlet"><i
                                            class="fa-solid fa-users"></i> Users</a>
                                </li>
                                <li>
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
                                <h4 class="mb-0">Dashboard</h4>
                                <div>
                                    <span class="me-3 fw-bold"><i class="fa-solid fa-user-shield text-primary"></i>
                                        <%= user.getName() %>
                                    </span>
                                    <a href="LoginServlet?action=logout"
                                        class="btn btn-sm btn-outline-danger">Logout</a>
                                </div>
                            </div>

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
                                                <!-- Manage Users Table -->
                                                <div class="col-lg-8">
                                                    <div class="card card-custom">
                                                        <div
                                                            class="card-header-custom d-flex justify-content-between align-items-center">
                                                            <span>Administrator Accounts</span>
                                                            <span class="badge bg-danger rounded-pill">
                                                                <% List<User> usersList = (List<User>)
                                                                        request.getAttribute("users");
                                                                        List<User> admins = new java.util.ArrayList<>();
                                                                                List<User> students = new
                                                                                    java.util.ArrayList<>();
                                                                                        if (usersList != null) {
                                                                                        for (User u : usersList) {
                                                                                        if ("admin".equals(u.getRole()))
                                                                                        admins.add(u);
                                                                                        else students.add(u);
                                                                                        }
                                                                                        }
                                                                                        out.print(admins.size());
                                                                                        %>
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
                                                                            <th>Role</th>
                                                                            <th>Password</th>
                                                                            <th>Actions</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <% if (!admins.isEmpty()) { for (User u :
                                                                            admins) { %>
                                                                            <tr>
                                                                                <td>#<%= u.getId() %>
                                                                                </td>
                                                                                <td class="fw-bold">
                                                                                    <%= u.getName() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= u.getEmail() %>
                                                                                </td>
                                                                                <td><span
                                                                                        class="badge bg-danger">Admin</span>
                                                                                </td>
                                                                                <td class="text-muted">
                                                                                    <%= u.getPassword() !=null ?
                                                                                        u.getPassword() : "******" %>
                                                                                </td>
                                                                                <td>
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-primary"
                                                                                        onclick="openEditModal('<%= u.getId() %>', '<%= u.getName() %>', '<%= u.getEmail() %>', '<%= u.getRole() %>')"
                                                                                        title="Edit">
                                                                                        <i class="fa-solid fa-edit"></i>
                                                                                        Edit
                                                                                    </button>
                                                                                    <form
                                                                                        action="<%=request.getContextPath()%>/AdminServlet"
                                                                                        method="POST" class="d-inline">
                                                                                        <input type="hidden"
                                                                                            name="action"
                                                                                            value="copyUser">
                                                                                        <input type="hidden" name="id"
                                                                                            value="<%= u.getId() %>">
                                                                                        <button type="submit"
                                                                                            class="btn btn-sm btn-outline-success"
                                                                                            title="Copy">
                                                                                            <i
                                                                                                class="fa-solid fa-copy"></i>
                                                                                            Copy
                                                                                        </button>
                                                                                    </form>
                                                                                    <form
                                                                                        action="<%=request.getContextPath()%>/AdminServlet"
                                                                                        method="POST" class="d-inline"
                                                                                        onsubmit="return confirm('Are you sure you want to delete this admin?');">
                                                                                        <input type="hidden"
                                                                                            name="action"
                                                                                            value="deleteUser">
                                                                                        <input type="hidden" name="id"
                                                                                            value="<%= u.getId() %>">
                                                                                        <button type="submit"
                                                                                            class="btn btn-sm btn-outline-danger"
                                                                                            title="Delete">
                                                                                            <i
                                                                                                class="fa-solid fa-trash"></i>
                                                                                            Delete
                                                                                        </button>
                                                                                    </form>
                                                                                </td>
                                                                            </tr>
                                                                            <% } } else { %>
                                                                                <tr>
                                                                                    <td colspan="6"
                                                                                        class="text-center py-4">No
                                                                                        users found in database.</td>
                                                                                </tr>
                                                                                <% } %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Manage Students Table -->
                                                    <div class="card card-custom">
                                                        <div
                                                            class="card-header-custom d-flex justify-content-between align-items-center">
                                                            <span>Registered Students</span>
                                                            <span class="badge bg-success rounded-pill">
                                                                <% out.print(students.size()); %>
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
                                                                            <th>Role</th>
                                                                            <th>Password</th>
                                                                            <th>Actions</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <% if (!students.isEmpty()) { for (User u :
                                                                            students) { %>
                                                                            <tr>
                                                                                <td>#<%= u.getId() %>
                                                                                </td>
                                                                                <td class="fw-bold">
                                                                                    <%= u.getName() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= u.getEmail() %>
                                                                                </td>
                                                                                <td><span
                                                                                        class="badge bg-success">Student</span>
                                                                                </td>
                                                                                <td class="text-muted">
                                                                                    <%= u.getPassword() !=null ?
                                                                                        u.getPassword() : "******" %>
                                                                                </td>
                                                                                <td>
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-primary"
                                                                                        onclick="openEditModal('<%= u.getId() %>', '<%= u.getName() %>', '<%= u.getEmail() %>', '<%= u.getRole() %>')"
                                                                                        title="Edit">
                                                                                        <i class="fa-solid fa-edit"></i>
                                                                                        Edit
                                                                                    </button>
                                                                                    <form
                                                                                        action="<%=request.getContextPath()%>/AdminServlet"
                                                                                        method="POST" class="d-inline">
                                                                                        <input type="hidden"
                                                                                            name="action"
                                                                                            value="copyUser">
                                                                                        <input type="hidden" name="id"
                                                                                            value="<%= u.getId() %>">
                                                                                        <button type="submit"
                                                                                            class="btn btn-sm btn-outline-success"
                                                                                            title="Copy">
                                                                                            <i
                                                                                                class="fa-solid fa-copy"></i>
                                                                                            Copy
                                                                                        </button>
                                                                                    </form>
                                                                                    <form
                                                                                        action="<%=request.getContextPath()%>/AdminServlet"
                                                                                        method="POST" class="d-inline"
                                                                                        onsubmit="return confirm('Are you sure you want to delete this student?');">
                                                                                        <input type="hidden"
                                                                                            name="action"
                                                                                            value="deleteUser">
                                                                                        <input type="hidden" name="id"
                                                                                            value="<%= u.getId() %>">
                                                                                        <button type="submit"
                                                                                            class="btn btn-sm btn-outline-danger"
                                                                                            title="Delete">
                                                                                            <i
                                                                                                class="fa-solid fa-trash"></i>
                                                                                            Delete
                                                                                        </button>
                                                                                    </form>
                                                                                </td>
                                                                            </tr>
                                                                            <% } } else { %>
                                                                                <tr>
                                                                                    <td colspan="6"
                                                                                        class="text-center py-4">No
                                                                                        student records found.</td>
                                                                                </tr>
                                                                                <% } %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Add Admin Form -->
                                                <div class="col-lg-4">
                                                    <div class="card card-custom">
                                                        <div class="card-header-custom">
                                                            Add New Admin
                                                        </div>
                                                        <div class="card-body">
                                                            <form action="<%=request.getContextPath()%>/AdminServlet"
                                                                method="POST">
                                                                <input type="hidden" name="action" value="addAdmin">

                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label text-muted small fw-bold">Full
                                                                        Name</label>
                                                                    <input type="text" class="form-control" name="name"
                                                                        required>
                                                                </div>

                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label text-muted small fw-bold">Email
                                                                        Address</label>
                                                                    <input type="email" class="form-control"
                                                                        name="email" required>
                                                                </div>

                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label text-muted small fw-bold">Password</label>
                                                                    <input type="password" class="form-control"
                                                                        name="password" required>
                                                                </div>

                                                                <button type="submit"
                                                                    class="btn btn-primary w-100">Create Admin
                                                                    Account</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                        </div>
                    </div>

                    <!-- Edit User Modal -->
                    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel"
                        aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="<%=request.getContextPath()%>/AdminServlet" method="POST">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="hidden" name="action" value="editUser">
                                        <input type="hidden" name="id" id="editUserId">

                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">Full Name</label>
                                            <input type="text" class="form-control" name="name" id="editUserName"
                                                required>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">Email Address</label>
                                            <input type="email" class="form-control" name="email" id="editUserEmail"
                                                required>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">Role</label>
                                            <select class="form-select" name="role" id="editUserRole" required>
                                                <option value="admin">Admin</option>
                                                <option value="student">Student</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">New Password (leave blank
                                                to keep current)</label>
                                            <input type="password" class="form-control" name="password">
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

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        function openEditModal(id, name, email, role) {
                            document.getElementById('editUserId').value = id;
                            document.getElementById('editUserName').value = name;
                            document.getElementById('editUserEmail').value = email;
                            document.getElementById('editUserRole').value = role;
                            var editModal = new bootstrap.Modal(document.getElementById('editUserModal'));
                            editModal.show();
                        }
                    </script>
                </body>

                </html>