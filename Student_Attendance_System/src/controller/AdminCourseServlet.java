package controller;

import dao.AttendanceDAO;
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

/**
 * Servlet handling admin course operations.
 */
@WebServlet("/AdminCourseServlet")
public class AdminCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseDAO courseDAO;
    private AttendanceDAO attendanceDAO;

    @Override
    public void init() {
        courseDAO = new CourseDAO();
        attendanceDAO = new AttendanceDAO();
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
            String lectureDay = request.getParameter("lectureDay");
            String lectureTime = request.getParameter("lectureTime");

            Course course = new Course();
            course.setCourseName(courseName);
            course.setCourseCode(courseCode);

            int courseId = courseDAO.createCourse(course);

            if (courseId > 0) {
                if (lectureDay != null && !lectureDay.isEmpty() && lectureTime != null && !lectureTime.isEmpty()) {
                    attendanceDAO.createLecture(courseId, lectureDay, java.time.LocalTime.parse(lectureTime));
                }
                response.sendRedirect("AdminCourseServlet?success=Course created successfully.");
            } else {
                response.sendRedirect("AdminCourseServlet?error=Failed to create course. Code might already exist.");
            }
        } else if ("editCourse".equals(action)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                String courseName = request.getParameter("courseName");
                String courseCode = request.getParameter("courseCode");

                Course course = new Course();
                course.setCourseId(courseId);
                course.setCourseName(courseName);
                course.setCourseCode(courseCode);

                boolean success = courseDAO.updateCourse(course);

                if (success) {
                    response.sendRedirect("AdminCourseServlet?success=Course updated successfully.");
                } else {
                    response.sendRedirect("AdminCourseServlet?error=Failed to update course.");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("AdminCourseServlet?error=Invalid course ID.");
            }
        } else if ("deleteCourse".equals(action)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                boolean success = courseDAO.deleteCourse(courseId);

                if (success) {
                    response.sendRedirect("AdminCourseServlet?success=Course and related records deleted successfully.");
                } else {
                    response.sendRedirect("AdminCourseServlet?error=Failed to delete course. It may not exist.");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("AdminCourseServlet?error=Invalid course ID.");
            }
        } else {
            response.sendRedirect("AdminCourseServlet");
        }
    }
}

