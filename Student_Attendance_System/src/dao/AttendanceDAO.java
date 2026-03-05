package dao;

import util.DBConnection;
import model.AttendanceDetail;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.Map;

public class AttendanceDAO {

    /**
     * Create a lecture row for a given course and day/time.
     *
     * @return generated lecture_id or -1 on failure
     */
    public int createLecture(int courseId, String lectureDate, LocalTime lectureTime) {
        String sql = "INSERT INTO lectures (course_id, lecture_date, lecture_time) VALUES (?, ?, ?)";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return -1;

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, courseId);
            ps.setString(2, lectureDate);
            ps.setTime(3, Time.valueOf(lectureTime));
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
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
     * Store attendance records for a lecture in batch.
     *
     * @param lectureId   lecture primary key
     * @param markedById  admin user id
     * @param statuses    map of studentId -> status ('present', 'absent', 'late')
     */
    public void saveAttendanceBatch(int lectureId, int markedById, Map<Integer, String> statuses) {
        if (statuses == null || statuses.isEmpty()) {
            return;
        }

        String sql = "INSERT INTO attendance (student_id, lecture_id, status, marked_by) VALUES (?, ?, ?, ?)";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Map.Entry<Integer, String> entry : statuses.entrySet()) {
                ps.setInt(1, entry.getKey());
                ps.setInt(2, lectureId);
                ps.setString(3, entry.getValue());
                ps.setInt(4, markedById);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
    }

    /**
     * Optional helper to quickly count how many times each status was used in a lecture.
     */
    public Map<String, Integer> getLectureSummary(int lectureId) {
        Map<String, Integer> summary = new HashMap<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM attendance WHERE lecture_id = ? GROUP BY status";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return summary;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lectureId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    summary.put(rs.getString("status"), rs.getInt("cnt"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return summary;
    }

    /**
     * Retrieves a summary of past lectures for a given course,
     * including total present / absent / late counts per lecture.
     */
    public java.util.List<model.LectureRecord> getPastLecturesSummary(int courseId) {
        java.util.List<model.LectureRecord> lectures = new java.util.ArrayList<>();

        String sql =
                "SELECT l.lecture_id, l.lecture_date, l.lecture_time, " +
                "SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS present_count, " +
                "SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS absent_count, " +
                "SUM(CASE WHEN a.status = 'late' THEN 1 ELSE 0 END) AS late_count " +
                "FROM lectures l " +
                "LEFT JOIN attendance a ON l.lecture_id = a.lecture_id " +
                "WHERE l.course_id = ? " +
                "GROUP BY l.lecture_id, l.lecture_date, l.lecture_time " +
                "ORDER BY l.lecture_date DESC, l.lecture_time DESC";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return lectures;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.LectureRecord record = new model.LectureRecord();
                    record.setLectureId(rs.getInt("lecture_id"));
                    record.setCourseId(courseId);

                    String date = rs.getString("lecture_date");
                    if (date != null) record.setLectureDate(date);

                    record.setLectureTime(rs.getString("lecture_time"));
                    record.setPresentCount(rs.getInt("present_count"));
                    record.setAbsentCount(rs.getInt("absent_count"));
                    record.setLateCount(rs.getInt("late_count"));

                    lectures.add(record);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return lectures;
    }

    /**
     * Returns per-student attendance details for a single lecture.
     */
    public java.util.List<AttendanceDetail> getLectureDetails(int lectureId) {
        java.util.List<AttendanceDetail> details = new java.util.ArrayList<>();

        String sql = "SELECT u.id AS student_id, u.name AS student_name, u.email AS student_email, " +
                     "a.status FROM attendance a " +
                     "INNER JOIN users u ON u.id = a.student_id " +
                     "WHERE a.lecture_id = ? " +
                     "ORDER BY u.name ASC";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return details;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lectureId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AttendanceDetail d = new AttendanceDetail();
                    d.setStudentId(rs.getInt("student_id"));
                    d.setStudentName(rs.getString("student_name"));
                    d.setStudentEmail(rs.getString("student_email"));
                    d.setStatus(rs.getString("status"));
                    details.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception e) {}
        }
        return details;
    }

    /**
     * Deletes a lecture and all of its attendance records.
     *
     * @param lectureId lecture primary key to delete
     * @return true if the lecture row was deleted, false otherwise
     */
    public boolean deleteLecture(int lectureId) {
        String deleteAttendanceSql = "DELETE FROM attendance WHERE lecture_id = ?";
        String deleteLectureSql = "DELETE FROM lectures WHERE lecture_id = ?";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try {
            conn.setAutoCommit(false);

            try (PreparedStatement psAttend = conn.prepareStatement(deleteAttendanceSql)) {
                psAttend.setInt(1, lectureId);
                psAttend.executeUpdate();
            }

            int affectedLectureRows = 0;
            try (PreparedStatement psLecture = conn.prepareStatement(deleteLectureSql)) {
                psLecture.setInt(1, lectureId);
                affectedLectureRows = psLecture.executeUpdate();
            }

            conn.commit();
            return affectedLectureRows > 0;
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try { conn.setAutoCommit(true); } catch (Exception ignored) {}
            try { conn.close(); } catch (Exception ignored) {}
        }
        return false;
    }
}
