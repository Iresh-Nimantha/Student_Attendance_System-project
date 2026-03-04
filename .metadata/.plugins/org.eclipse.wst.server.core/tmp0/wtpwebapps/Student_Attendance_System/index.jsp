<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Attendance System - Welcome</title>
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
        .hero-section {
            background: rgba(255, 255, 255, 0.9);
            padding: 4rem 3rem;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 600px;
            width: 100%;
            backdrop-filter: blur(10px);
        }
        .hero-title {
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 1rem;
            font-size: 2.5rem;
        }
        .hero-subtitle {
            color: #7f8c8d;
            margin-bottom: 2.5rem;
            font-size: 1.1rem;
        }
        .btn-custom {
            padding: 12px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        .btn-login {
            background-color: #3498db;
            color: white;
            border: 2px solid #3498db;
        }
        .btn-login:hover {
            background-color: transparent;
            color: #3498db;
        }
        .btn-signup {
            background-color: transparent;
            color: #2ecc71;
            border: 2px solid #2ecc71;
        }
        .btn-signup:hover {
            background-color: #2ecc71;
            color: white;
        }
    </style>
</head>
<body>

<div class="container d-flex justify-content-center">
    <div class="hero-section">
        <h1 class="hero-title">Smart Attendance System</h1>
        <p class="hero-subtitle">Streamline your academic journey. Enroll in courses and easily track your attendance with our modern platform.</p>
        
        <div class="d-flex justify-content-center gap-4">
            <a href="login.jsp" class="btn btn-custom btn-login px-5">Login</a>
            <a href="signup.jsp" class="btn btn-custom btn-signup px-5">Sign Up</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
