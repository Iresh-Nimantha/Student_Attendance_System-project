package model;

import java.time.LocalTime;

public class Course {
    private int courseId;
    private String courseName;
    private String courseCode;
    
    // Transient fields to hold default scheduled lecture info
    private String lectureDay;
    private String lectureTime;

    public Course() {
    }

    public Course(int courseId, String courseName, String courseCode) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.courseCode = courseCode;
    }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public String getCourseCode() { return courseCode; }
    public void setCourseCode(String courseCode) { this.courseCode = courseCode; }

    public String getLectureDay() { return lectureDay; }
    public void setLectureDay(String lectureDay) { this.lectureDay = lectureDay; }

    public String getLectureTime() { return lectureTime; }
    public void setLectureTime(String lectureTime) { this.lectureTime = lectureTime; }
}
