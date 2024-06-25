-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3028

update gvk_emri_pregnant_member_responce set verification_reason = null where is_pregnant = true and verification_reason is not null;