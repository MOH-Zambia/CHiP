package com.argusoft.imtecho.common.dto;

import com.argusoft.imtecho.common.model.AnnouncementMaster;

import java.util.List;

public class AnnouncementPushNotificationDto {
    private AnnouncementMaster announcementMaster;
    private List<Integer> users;

    public AnnouncementMaster getAnnouncementMaster() {
        return announcementMaster;
    }

    public void setAnnouncementMaster(AnnouncementMaster announcementMaster) {
        this.announcementMaster = announcementMaster;
    }

    public List<Integer> getUsers() {
        return users;
    }

    public void setUsers(List<Integer> users) {
        this.users = users;
    }
}
