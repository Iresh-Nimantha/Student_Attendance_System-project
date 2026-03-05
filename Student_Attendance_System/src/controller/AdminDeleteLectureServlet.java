package controller;

import dao.AttendanceDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Handles deletion of a single lecture (and its attendance records)
 * from the "Past Lectures Summary" section.
 */
@WebServlet("/AdminDeleteLectureServlet")
public class AdminDeleteLectureServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AttendanceDAO attendanceDAO;

    @Override
    public void init() {
        attendanceDAO = new AttendanceDAO();
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

        String lectureIdParam = request.getParameter("lectureId");
        String courseIdParam = request.getParameter("courseId");

        int lectureId;
        int courseId;
        try {
            lectureId = Integer.parseInt(lectureIdParam);
            courseId = Integer.parseInt(courseIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("AdminCourseServlet?error=Invalid lecture or course.");
            return;
        }

        boolean deleted = attendanceDAO.deleteLecture(lectureId);

        if (deleted) {
            response.sendRedirect("AdminAttendanceServlet?courseId=" + courseId + "&success=Lecture deleted successfully.");
        } else {
            response.sendRedirect("AdminAttendanceServlet?courseId=" + courseId + "&error=Failed to delete lecture.");
        }
    }
}

