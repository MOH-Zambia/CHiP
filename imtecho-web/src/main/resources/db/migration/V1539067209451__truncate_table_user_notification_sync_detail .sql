TRUNCATE TABLE user_notification_sync_detail;
DELETE FROM techo_notification_master WHERE member_id = -1;
DELETE FROM event_mobile_notification_pending WHERE member_id = -1;