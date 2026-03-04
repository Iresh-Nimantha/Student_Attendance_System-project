package controller;

import dao.CourseDAO;
import model.Course;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminCourseServlet")
public class AdminCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseDAO courseDAO;

    @Override
    public void init() {
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"admin".equals(currentUser.getRole())) {
            response.sendRedirect("profile.jsp");
            return;
        }

        List<Course> courses = courseDAO.getAllCourses();
        request.setAttribute("courses", courses);

        request.getRequestDispatcher("admin_courses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"admin".equals(currentUser.getRole())) {
            response.sendRedirect("profile.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("addCourse".equals(action)) {
            String courseName = request.getParameter("courseName");
            String courseCode = request.getParameter("courseCode");

            Course course = new Course();
            course.setCourseName(courseName);
            course.setCourseCode(courseCode);

            boolean success = courseDAO.createCourse(course);

            if (success) {
                response.sendRedirect("AdminCourseServlet?success=Course created successfully.");
            } else {
                response.sendRedirect("AdminCourseServlet?error=Failed to create course. Code might already exist.");
            }
        } else {
            response.sendRedirect("AdminCourseServlet");
        }
    }
}

