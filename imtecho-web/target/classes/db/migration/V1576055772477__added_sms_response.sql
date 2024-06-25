DROP TABLE if exists sms_response;

CREATE TABLE sms_response
(
  a2wackid text NOT NULL,
  a2wstatus text,
  carrierstatus text,
  lastutime text,
  custref text,
  submitdt text,
  mnumber text,
  acode text,
  senderid text,
  created_on timestamp without time zone,
  CONSTRAINT sms_response_pkey PRIMARY KEY (a2wackid)
);