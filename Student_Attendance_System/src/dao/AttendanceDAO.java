package dao;

import util.DBConnection;

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
     * Create a lecture row for a given course and date/time.
     *
     * @return generated lecture_id or -1 on failure
     */
    public int createLecture(int courseId, LocalDate lectureDate, LocalTime lectureTime) {
        String sql = "INSERT INTO lectures (course_id, lecture_date, lecture_time) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, courseId);
            ps.setDate(2, Date.valueOf(lectureDate));
            ps.setTime(3, Time.valueOf(lectureTime));
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
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

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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
        }
    }

    /**
     * Optional helper to quickly count how many times each status was used in a lecture.
     */
    public Map<String, Integer> getLectureSummary(int lectureId) {
        Map<String, Integer> summary = new HashMap<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM attendance WHERE lecture_id = ? GROUP BY status";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lectureId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    summary.put(rs.getString("status"), rs.getInt("cnt"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return summary;
    }
}

