package controller;

import dao.AttendanceDAO;
import model.AttendanceDetail;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminLectureDetailsServlet")
public class AdminLectureDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AttendanceDAO attendanceDAO;

    @Override
    public void init() {
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

        String lectureIdParam = request.getParameter("lectureId");
        String courseIdParam = request.getParameter("courseId");
        if (lectureIdParam == null || courseIdParam == null) {
            response.sendRedirect("AdminServlet?error=Missing lecture or course information.");
            return;
        }

        int lectureId;
        int courseId;
        try {
            lectureId = Integer.parseInt(lectureIdParam);
            courseId = Integer.parseInt(courseIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("AdminServlet?error=Invalid lecture or course id.");
            return;
        }

        List<AttendanceDetail> details = attendanceDAO.getLectureDetails(lectureId);

        request.setAttribute("lectureDetails", details);
        request.setAttribute("courseId", courseId);
        request.setAttribute("lectureDate", request.getParameter("lectureDate"));
        request.setAttribute("lectureTime", request.getParameter("lectureTime"));

        request.getRequestDispatcher("admin_lecture_details.jsp").forward(request, response);
    }
}

