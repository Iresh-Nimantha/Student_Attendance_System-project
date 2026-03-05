package dao;

import model.Course;
import model.User;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data access object for course-related operations.
 *
 * Responsibilities:
 * - CRUD for courses
 * - Managing student enrollments
 * - Looking up course and enrollment data used by servlets/JSPs
 */
public class CourseDAO {

    public java.util.List<Course> getAllCourses() {
        java.util.List<Course> courses = new java.util.ArrayList<>();
        String query = "SELECT * FROM courses ORDER BY course_name ASC";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return courses;

        try (PreparedStatement pstmt = conn.prepareStatement(query);
             java.sql.ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setCourseName(rs.getString("course_name"));
                course.setCourseCode(rs.getString("course_code"));
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return courses;
    }

    public java.util.List<Course> getCoursesByStudentId(int studentId) {
        java.util.List<Course> courses = new java.util.ArrayList<>();
        String query = "SELECT c.*, l.lecture_date, l.lecture_time FROM courses c " +
                       "INNER JOIN enrollments e ON c.course_id = e.course_id " +
                       "LEFT JOIN lectures l ON c.course_id = l.course_id " +
                       "WHERE e.student_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return courses;

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, studentId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getInt("course_id"));
                    course.setCourseName(rs.getString("course_name"));
                    course.setCourseCode(rs.getString("course_code"));
                    
                    course.setLectureDay(rs.getString("lecture_date"));
                    course.setLectureTime(rs.getString("lecture_time"));
                    
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return courses;
    }

    public java.util.List<Course> getAvailableCoursesForStudent(int studentId) {
        java.util.List<Course> courses = new java.util.ArrayList<>();
        String query = "SELECT c.*, l.lecture_date, l.lecture_time FROM courses c " +
                       "LEFT JOIN lectures l ON c.course_id = l.course_id " +
                       "WHERE c.course_id NOT IN (SELECT course_id FROM enrollments WHERE student_id = ?)";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return courses;

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, studentId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getInt("course_id"));
                    course.setCourseName(rs.getString("course_name"));
                    course.setCourseCode(rs.getString("course_code"));
                    
                    course.setLectureDay(rs.getString("lecture_date"));
                    course.setLectureTime(rs.getString("lecture_time"));
                    
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return courses;
    }

    public boolean enrollStudent(int studentId, int courseId) {
        String query = "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, courseId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return false;
    }

    public boolean unenrollStudent(int studentId, int courseId) {
        String query = "DELETE FROM enrollments WHERE student_id = ? AND course_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, courseId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return false;
    }

    /**
     * Fetch a single course by its primary key.
     */
    public Course getCourseById(int courseId) {
        Course course = null;
        String query = "SELECT c.*, l.lecture_date, l.lecture_time FROM courses c " +
                       "LEFT JOIN lectures l ON c.course_id = l.course_id " +
                       "WHERE c.course_id = ? LIMIT 1";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return null;

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, courseId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    course = new Course();
                    course.setCourseId(rs.getInt("course_id"));
                    course.setCourseName(rs.getString("course_name"));
                    course.setCourseCode(rs.getString("course_code"));

                    course.setLectureDay(rs.getString("lecture_date"));
                    course.setLectureTime(rs.getString("lecture_time"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return course;
    }

    /**
     * Return all students enrolled in a given course.
     */
    public java.util.List<User> getStudentsForCourse(int courseId) {
        java.util.List<User> students = new java.util.ArrayList<>();
        String query = "SELECT u.* FROM users u INNER JOIN enrollments e ON u.id = e.student_id WHERE e.course_id = ? AND u.role = 'student' ORDER BY u.name ASC";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return students;

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, courseId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    User student = new User();
                    student.setId(rs.getInt("id"));
                    student.setName(rs.getString("name"));
                    student.setEmail(rs.getString("email"));
                    student.setRole(rs.getString("role"));
                    students.add(student);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return students;
    }
    /**
     * Update an existing course's details.
     */
    public boolean updateCourse(Course course) {
        String query = "UPDATE courses SET course_name = ?, course_code = ? WHERE course_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, course.getCourseName());
            pstmt.setString(2, course.getCourseCode());
            pstmt.setInt(3, course.getCourseId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return false;
    }

    /**
     * Creates a new course and returns the generated primary key.
     */
    public int createCourse(Course course) {
        String query = "INSERT INTO courses (course_name, course_code) VALUES (?, ?)";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return -1;

        try (PreparedStatement pstmt = conn.prepareStatement(query, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, course.getCourseName());
            pstmt.setString(2, course.getCourseCode());

            pstmt.executeUpdate();
            try (java.sql.ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return -1;
    }

    /**
     * Delete a course. To prevent Foreign Key constraint violations,
     * this manually deletes dependent records from attendance, lectures, and enrollments first.
     */
    public boolean deleteCourse(int courseId) {
        String delAttendance = "DELETE a FROM attendance a INNER JOIN lectures l ON a.lecture_id = l.lecture_id WHERE l.course_id = ?";
        String delLectures = "DELETE FROM lectures WHERE course_id = ?";
        String delEnrollments = "DELETE FROM enrollments WHERE course_id = ?";
        String delCourse = "DELETE FROM courses WHERE course_id = ?";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try {
            conn.setAutoCommit(false); // Start transaction

            // 1. Delete attendance records linked to the course's lectures
            try (PreparedStatement ps1 = conn.prepareStatement(delAttendance)) {
                ps1.setInt(1, courseId);
                ps1.executeUpdate();
            }

            // 2. Delete the course's lectures
            try (PreparedStatement ps2 = conn.prepareStatement(delLectures)) {
                ps2.setInt(1, courseId);
                ps2.executeUpdate();
            }

            // 3. Delete student enrollments for this course
            try (PreparedStatement ps3 = conn.prepareStatement(delEnrollments)) {
                ps3.setInt(1, courseId);
                ps3.executeUpdate();
            }

            // 4. Finally, delete the actual course
            boolean isDeleted = false;
            try (PreparedStatement ps4 = conn.prepareStatement(delCourse)) {
                ps4.setInt(1, courseId);
                isDeleted = ps4.executeUpdate() > 0;
            }

            conn.commit(); // End transaction successfully
            return isDeleted;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }
}
