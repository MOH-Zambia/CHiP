package com.argusoft.imtecho.course.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "tr_course_notification_type_rel")
public class CourseNotificationTypeRel extends EntityAuditInfo implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "course_id")
    private Integer courseId;

    @Column(name = "push_notification_type_id")
    private Integer pushNotificationTypeId;

    @Column(name="day")
    private Integer day;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getCourseId() {
        return courseId;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
    }

    public Integer getPushNotificationTypeId() {
        return pushNotificationTypeId;
    }

    public void setPushNotificationTypeId(Integer pushNotificationTypeId) {
        this.pushNotificationTypeId = pushNotificationTypeId;
    }

    public Integer getDay() {
        return day;
    }

    public void setDay(Integer day) {
        this.day = day;
    }
}
