drop table if exists sms_response;

CREATE TABLE sms_response(
    a2wackid text PRIMARY KEY,
    a2wstatus text,
    carrierstatus text,
    lastutime timestamp without time zone,
    custref text,
    submitdt timestamp without time zone,
    mnumber text,
    Sts timestamp without time zone,
    Msg text,
    Acode text,
    Senderid text,
    created_on timestamp without time zone   
);