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
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/AdminAttendanceServlet")
public class AdminAttendanceServlet extends HttpServlet {
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

        String courseIdParam = request.getParameter("courseId");
        if (courseIdParam == null) {
            response.sendRedirect("AdminCourseServlet?error=Please select a course first.");
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("AdminCourseServlet?error=Invalid course selection.");
            return;
        }

        Course course = courseDAO.getCourseById(courseId);
        if (course == null) {
            response.sendRedirect("AdminCourseServlet?error=Course not found.");
            return;
        }

        List<User> students = courseDAO.getStudentsForCourse(courseId);

        request.setAttribute("course", course);
        request.setAttribute("students", students);
        request.setAttribute("courseId", courseId);

        request.getRequestDispatcher("admin_attendance.jsp").forward(request, response);
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

        String courseIdParam = request.getParameter("courseId");
        String dateParam = request.getParameter("lectureDate");
        String timeParam = request.getParameter("lectureTime");

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("AdminCourseServlet?error=Invalid course selection.");
            return;
        }

        if (dateParam == null || timeParam == null || dateParam.isEmpty() || timeParam.isEmpty()) {
            response.sendRedirect("AdminAttendanceServlet?courseId=" + courseId + "&error=Please select date and time.");
            return;
        }

        LocalDate lectureDate = LocalDate.parse(dateParam);
        LocalTime lectureTime = LocalTime.parse(timeParam);

        int lectureId = attendanceDAO.createLecture(courseId, lectureDate, lectureTime);
        if (lectureId <= 0) {
            response.sendRedirect("AdminAttendanceServlet?courseId=" + courseId + "&error=Failed to create lecture.");
            return;
        }

        Map<Integer, String> statuses = new HashMap<>();
        Map<String, String[]> parameterMap = request.getParameterMap();

        for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
            String paramName = entry.getKey();
            if (paramName.startsWith("status_")) {
                String[] values = entry.getValue();
                if (values.length > 0) {
                    try {
                        int studentId = Integer.parseInt(paramName.substring("status_".length()));
                        String status = values[0];
                        statuses.put(studentId, status);
                    } catch (NumberFormatException ignored) {
                    }
                }
            }
        }

        attendanceDAO.saveAttendanceBatch(lectureId, currentUser.getId(), statuses);

        response.sendRedirect("AdminAttendanceServlet?courseId=" + courseId + "&success=Attendance saved successfully.");
    }
}

