package controller;

import dao.UserDAO;
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
 * Main admin dashboard controller.
 *
 * GET:  shows the dashboard with all users split into Admins vs Students.
 * POST: handles create/update/delete/copy actions on user accounts.
 */
@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

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

        // Fetch all users to display on the dashboard
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

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
        if ("addAdmin".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            User newAdmin = new User();
            newAdmin.setName(name);
            newAdmin.setEmail(email);
            newAdmin.setPassword(password);

            boolean success = userDAO.registerAdmin(newAdmin);
            
            if (success) {
                response.sendRedirect("AdminServlet?success=New admin added successfully.");
            } else {
                response.sendRedirect("AdminServlet?error=Failed to add admin. Email might exist.");
            }
        } else if ("deleteUser".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                if (id == currentUser.getId()) {
                    response.sendRedirect("AdminServlet?error=Cannot delete your own account.");
                } else {
                    boolean success = userDAO.deleteUser(id);
                    if (success) {
                        response.sendRedirect("AdminServlet?success=User deleted successfully.");
                    } else {
                        response.sendRedirect("AdminServlet?error=Failed to delete user.");
                    }
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("AdminServlet?error=Invalid user ID.");
            }
        } else if ("copyUser".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = userDAO.copyUser(id);
                if (success) {
                    response.sendRedirect("AdminServlet?success=User copied successfully.");
                } else {
                    response.sendRedirect("AdminServlet?error=Failed to copy user.");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("AdminServlet?error=Invalid user ID.");
            }
        } else if ("editUser".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                User userToUpdate = userDAO.getUserById(id);
                if (userToUpdate != null) {
                    userToUpdate.setName(name);
                    userToUpdate.setEmail(email);
                    if (password != null && !password.isEmpty()) {
                        userToUpdate.setPassword(password);
                    }
                    userToUpdate.setRole(role);
                    
                    boolean success = userDAO.updateUser(userToUpdate);
                    if (success) {
                        response.sendRedirect("AdminServlet?success=User updated successfully.");
                    } else {
                        response.sendRedirect("AdminServlet?error=Failed to update user.");
                    }
                } else {
                    response.sendRedirect("AdminServlet?error=User not found.");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("AdminServlet?error=Invalid user ID.");
            }
        } else {
            response.sendRedirect("AdminServlet");
        }
    }
}
