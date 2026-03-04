<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sign Up - Smart Attendance</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .signup-container {
                background: rgba(255, 255, 255, 0.95);
                padding: 3rem;
                border-radius: 15px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                max-width: 450px;
                width: 100%;
            }

            .signup-title {
                text-align: center;
                margin-bottom: 2rem;
                color: #2c3e50;
                font-weight: 700;
            }

            .form-control {
                border-radius: 10px;
                padding: 12px 15px;
                margin-bottom: 1.5rem;
                border: 1px solid #ddd;
                transition: all 0.3s;
            }

            .form-control:focus {
                box-shadow: 0 0 10px rgba(52, 152, 219, 0.2);
                border-color: #3498db;
            }

            .btn-register {
                width: 100%;
                padding: 12px;
                background-color: #2ecc71;
                border: none;
                color: white;
                font-weight: 600;
                border-radius: 10px;
                font-size: 1.1rem;
                transition: background-color 0.3s;
            }

            .btn-register:hover {
                background-color: #27ae60;
                color: white;
            }

            .login-link {
                text-align: center;
                margin-top: 1.5rem;
            }

            .login-link a {
                color: #3498db;
                text-decoration: none;
                font-weight: 600;
            }
        </style>
    </head>

    <body>

        <div class="container d-flex justify-content-center">
            <div class="signup-container">
                <h2 class="signup-title">Create Account</h2>

                <% if (request.getParameter("error") !=null) { %>
                    <div class="alert alert-danger" role="alert">
                        <%= request.getParameter("error") %>
                    </div>
                    <% } %>

                        <form action="<%=request.getContextPath()%>/RegisterServlet" method="POST">
                            <div class="mb-3">
                                <input type="text" class="form-control" name="name" placeholder="Full Name" required>
                            </div>

                            <div class="mb-3">
                                <input type="email" class="form-control" name="email" placeholder="Email Address"
                                    required>
                            </div>

                            <div class="mb-3">
                                <input type="password" class="form-control" name="password" placeholder="Password"
                                    required>
                            </div>

                            <button type="submit" class="btn btn-register">Sign Up</button>
                        </form>

                        <div class="login-link">
                            Already have an account? <a href="login.jsp">Login here</a>
                        </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>