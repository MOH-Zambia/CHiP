DELETE FROM system_configuration  where system_key in ('EXCEPTION_MAIL_MESSAGE_WS_TECHO','EXCEPTION_MAIL_SUBJECT_TECHO','EXCEPTION_MAIL_SEND_TO_TECHO');

INSERT INTO system_configuration  values ('EXCEPTION_MAIL_MESSAGE_WS_TECHO',true,'Exception From TeCHO Production Web Service');
INSERT INTO system_configuration  values ('EXCEPTION_MAIL_SUBJECT_TECHO',true,'Exception From TeCHO');
INSERT INTO system_configuration  values ('EXCEPTION_MAIL_SEND_TO_TECHO',true,'kunjanp@argusoft.com,hshah@argusoft.com');