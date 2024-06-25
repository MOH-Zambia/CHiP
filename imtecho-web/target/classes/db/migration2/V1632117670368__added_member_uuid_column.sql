ALTER table imt_member
DROP column if exists member_uuid,
ADD column member_uuid varchar(255);