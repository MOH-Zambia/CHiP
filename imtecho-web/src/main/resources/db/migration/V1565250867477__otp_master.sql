create table if not exists otp_master(
mobile_number text,
otp text,
expiry timestamp without time zone
);