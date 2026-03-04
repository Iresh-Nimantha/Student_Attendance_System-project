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

@WebServlet("/CourseServlet")
public class CourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseDAO courseDAO;

    @Override
    public void init() {
        courseDAO = new CourseDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        // Load all available courses
        List<Course> allCourses = courseDAO.getAllCourses();
        // Load courses enrolled by this student
        List<Course> enrolledCourses = courseDAO.getCoursesByStudentId(user.getId());

        request.setAttribute("allCourses", allCourses);
        request.setAttribute("enrolledCourses", enrolledCourses);

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String courseIdStr = request.getParameter("courseId");

        if (courseIdStr != null && !courseIdStr.isEmpty()) {
            try {
                int courseId = Integer.parseInt(courseIdStr);
                boolean success = courseDAO.enrollStudentInCourse(user.getId(), courseId);
                
                if (success) {
                    response.sendRedirect("CourseServlet?success=Successfully enrolled in course.");
                } else {
                    response.sendRedirect("CourseServlet?error=Enrollment failed. You might already be enrolled.");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("CourseServlet?error=Invalid course selection.");
            }
        } else {
            response.sendRedirect("CourseServlet?error=Please select a course.");
        }
    }
}
