package model;

/**
 * Lightweight view model representing a single lecture session,
 * used in the "Past Lectures Summary" table.
 *
 * Each instance represents one lecture with aggregated attendance counts.
 * Per-student details are handled separately via {@link model.AttendanceDetail}.
 */
public class LectureRecord {
    private int lectureId;
    private int courseId;
    private String lectureDate;
    private String lectureTime;

    private int presentCount;
    private int absentCount;
    private int lateCount;

    public int getLectureId() { return lectureId; }
    public void setLectureId(int lectureId) { this.lectureId = lectureId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getLectureDate() { return lectureDate; }
    public void setLectureDate(String lectureDate) { this.lectureDate = lectureDate; }

    public String getLectureTime() { return lectureTime; }
    public void setLectureTime(String lectureTime) { this.lectureTime = lectureTime; }

    public int getPresentCount() { return presentCount; }
    public void setPresentCount(int presentCount) { this.presentCount = presentCount; }

    public int getAbsentCount() { return absentCount; }
    public void setAbsentCount(int absentCount) { this.absentCount = absentCount; }

    public int getLateCount() { return lateCount; }
    public void setLateCount(int lateCount) { this.lateCount = lateCount; }
}
