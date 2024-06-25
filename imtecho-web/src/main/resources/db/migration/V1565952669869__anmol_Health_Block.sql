
CREATE TABLE anmol_Health_Block (
	BID int NOT NULL,
	Name_E varchar(50) NULL,
	Name_G varchar(50) NULL,
	HQ varchar(50) NULL,
	DCode int NULL,
	TCode varchar(7) NULL,
	Created_by int NULL,
	Created_On timestamp without time zone ,
	Modified_By int NULL,
	Modified_On timestamp without time zone ,
	IsActive INT NULL,
	MDDS_Code int NULL,
	IsVerified INT NULL,
	IsRCH INT NULL,
	HB_TypeID INT NULL,
	SR_IMI INT NULL
);



INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(1,'City','અમદાવાદ સીટી','C.H.C Sarkhej',7005,'7005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4049,1,NULL,NULL,NULL)
,(2,'Dascroi,','દસક્રોઇ','Civil Hosp.Sola',7,'7006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4052,1,NULL,NULL,NULL)
,(3,'Viramgam','વિરમગામ','C.H.C. Viramgam',7,'7003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
,(4,'Sanad','સાણંદ','C.H.C. Sanad',7,'7004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4058,1,NULL,NULL,1)
,(5,'Dholka','ધોળકા','C.H.C. Dholka',7,'7007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4055,1,NULL,NULL,1)
,(6,'Bavla','બાવળા','C.H.C. Bavla',7,'7008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4051,1,NULL,NULL,NULL)
,(7,'Dhandhuka','ધંધુકા','C.H.C .Dhandhuka',7,'7011',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4054,1,NULL,NULL,NULL)
,(8,'Nadiad','નડિયાદ Rural','DTC Nadiad',16,'16008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4163,1,NULL,NULL,NULL)
,(9,'Mahudha','મહુધા','C.H.C. Mahudha',16,'16009',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4160,1,NULL,NULL,NULL)
,(10,'Thasara','ઠાસરા','C.H.C.Thasara',16,'16010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4164,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(11,'Balasinor,Virpur','બાલાસિનોર','C.H.C. Balasinor',32,'32005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(12,'Kapadwanj','કપડવંજ','C.H.C.Antarsuba',16,'16001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4157,1,NULL,NULL,NULL)
,(13,'Kathalal','કઠલાલ','C.H.C Kathalal',16,'16004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4158,1,NULL,NULL,1)
,(14,'Mahemdabad','મહેમદાવાદ','Sub-division Office Mahemdabad',16,'16005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4162,1,NULL,NULL,NULL)
,(15,'Kheda/Matar','ખેડા','Gen.Hosp.Kheda',16,'16006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(16,'Anand','આણંદ','P.H.C.Karmsad',15,'15004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4071,1,NULL,NULL,NULL)
,(17,'Borsad','બોરસદ',NULL,15,'15007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(18,'Khambhat','ખંભાત','C.H.C. Khambhat',15,'15006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4074,1,NULL,NULL,1)
,(19,'Petlad','પેટલાદ','D.T.C. Petlad',15,'15005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(20,'Umreth','ઉમરેઠ','C.H.C. Umreth',15,'15003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4078,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(21,'Patdi(Dasada)','દસાડા','C.H.C. Patdi.',8,'8003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4249,1,NULL,NULL,1)
,(22,'Dhangadhra','ધાંગધ્રા','C.H.C. Dhangadhra',8,'8002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4250,1,NULL,NULL,NULL)
,(23,'Chotila','ચોટીલા','C.H.C .Chotila',8,'8007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4247,1,NULL,NULL,1)
,(24,'Sayla','સાયલા','C.H.C. Sayla',8,'8008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(25,'Limdi','લીંબડી','Gen.Hosp.Limdi',8,'8010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
,(26,'Vadhvan','વઢવાણ','C.H.C. Lakhatar',8,'8005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
,(27,'Halvad','હળવદ','C.H.C. Halvad',28,'28005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4251,1,NULL,NULL,NULL)
,(28,'Gandhinagar','ગાંધીનગર','Sec-5.Dispensary.',6,'6003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4119,1,NULL,NULL,NULL)
,(29,'Dehgam','દહેગામ','C.H.C. Dehgam',6,'6004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4118,1,NULL,NULL,NULL)
,(30,'Kalol','કલોલ','PP Unit.Kalol',6,'6001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4120,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(31,'Mansa','માણસા','DTC mansa',6,'6002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4121,1,NULL,NULL,NULL)
,(32,'Prantij','પ્રાંતિજ','C.H.C. Prantij',5,'5008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4228,1,NULL,NULL,NULL)
,(33,'Talod','તલોદ','C.H.C. Talod',5,'5009',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4229,1,NULL,NULL,NULL)
,(34,'Bayad','બાયડ','C.H.C. Bayad',31,'31013',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4219,1,NULL,NULL,NULL)
,(35,'Megharaj-T','મેઘરજ','C.H.C. Megharaj',31,'31006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4226,1,NULL,NULL,NULL)
,(36,'Bhiloda-T','ભીલોડા','Cottage Hosp.Bhiloda',31,'31005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4220,1,NULL,NULL,NULL)
,(37,'Modasa','મોડાસા','Phc Modasa',31,'31010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4227,1,NULL,NULL,NULL)
,(38,'Vijaynagar-T','વિજયનગર','C.H.C. Vijaynagar',5,'5002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4231,1,NULL,NULL,NULL)
,(39,'Idar-T','ઇડર','C.H.C. Idar',5,'5004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4223,1,NULL,NULL,1)
,(40,'Himmatnagar','હિંમતનગર','C.H.C .Himmatnagar',5,'5007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4222,1,NULL,NULL,1)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(41,'Khedbrahma-T','ખેડબ્રહ્મા','C.H.C. Khedbrahma',5,'5001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4224,1,NULL,NULL,NULL)
,(42,'Vav','વાવ','C.H.C. Vav',2,'2001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4090,1,NULL,NULL,1)
,(43,'Tharad','થરાદ','C.H.C. Tharad',2,'2002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4088,1,NULL,NULL,1)
,(44,'Dhanera','ધાનેરા','C.H.C. Dhanera',2,'2003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
,(45,'Amirgadh -T','અમીરગઢ','C.H.C .Amirgadh',2,'2005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4079,1,NULL,NULL,NULL)
,(46,'Danta-T  ','દાંતા','P.H.C. Danta',2,'2006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4081,1,NULL,NULL,NULL)
,(47,'Vadgam','વડગામ','C.H.C .Vadgam',2,'2007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4089,1,NULL,NULL,1)
,(48,'Disa','ડીસા','Gen.Hosp.Disa',2,'2009',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4083,1,NULL,NULL,NULL)
,(49,'Diyodar','દીયોદર','C.H.C. Bhabhar',2,'2010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(50,'Kankrej','કાંકરેજ','C.H.C. Kankrej',2,'2012',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4086,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(51,'Palanpur','પાલનપુર','Medani.Eye.hosp.Palanpur',2,'2008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4087,1,NULL,NULL,NULL)
,(52,'Chanasma','ચાણસ્મા','P.H.C. Chanasama',3,'3008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4195,1,NULL,NULL,NULL)
,(53,'Patan','પાટણ','PPUnit Patan',3,'3005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4197,1,NULL,NULL,NULL)
,(54,'Radhanpur','રાધનપુર','C.H.C.Radhanpur',3,'3002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4198,1,NULL,NULL,NULL)
,(55,'Santalpur','સાંતલપુર','P.H.C. Varahi.',3,'3001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4200,1,NULL,NULL,NULL)
,(56,'Sami','સમી','C.H.C. Sami',3,'3007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4199,1,NULL,NULL,NULL)
,(57,'Siddhpur','સિધ્ધપુર','C.H.C. Siddhpur',3,'3004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4201,1,NULL,NULL,NULL)
,(58,'Satlasna','સતલાસણા','Satlasna Hospital',4,'4001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
,(59,'Unjha','ઉંઝા','Cottege  Hosp.Unjha',4,'4003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4171,1,NULL,NULL,NULL)
,(60,'Visnagar','વિસનગર','FHW Traning School  Visnagar',4,'4004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4174,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(61,'Vijapur','વિજાપુર','CHC Vijapur',4,'4006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4173,1,NULL,NULL,NULL)
,(62,'Vadnagar','વડનગર','C.H.C. vadnagar',4,'4005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4172,1,NULL,NULL,NULL)
,(63,'Mehsana','મહેસાણા','Gen.Hosp. Mehasana',4,'4007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4169,1,NULL,NULL,NULL)
,(64,'Kadi','કડી','C.H.C. Kadi.',4,'4009',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(65,'Becharaji','બેચરાજી','C.H.C. Becharaji',4,'4008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4166,1,NULL,NULL,NULL)
,(66,'Savali','સાવલી','C.H.C.  Savli',19,'19001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4265,1,NULL,NULL,NULL)
,(67,'Vadodara','વડોદરા  RURAL','C.H.C.  Chhani',19,'19002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4267,1,NULL,NULL,NULL)
,(68,'Vaghodia','વાઘોડિયા','P.H.C. Vaghodia',19,'19003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4268,1,NULL,NULL,NULL)
,(69,'Jetpur Pavi','જેતપુર પાવી','C.H.C.  Jetpur pavi',33,'33004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4259,1,NULL,NULL,NULL)
,(70,'Chhota udepur-T','છોટા ઉદેપુર','C.H.C.  Chhotaudepur',33,'33005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4257,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(71,'Kawant-T','ક્વાન્ટ','C.H.C. Kanwat',33,'33006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4261,1,NULL,NULL,NULL)
,(72,'Nasvadi -T.','નસવાડી','C.H.C.  Nasvadi',33,'33007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4262,1,NULL,NULL,NULL)
,(73,'Sankheda-T.','સંખેડા','C.H.C.  Sankheda',33,'33008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4264,1,NULL,NULL,NULL)
,(74,'Dabhoi','ડભોઇ','C.H.C.  Dabhoi.',19,'19009',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4258,1,NULL,NULL,NULL)
,(75,'Padra','પાદરા','C.H.C.  Padra D.V. Training Centre , Padra',19,'19010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4263,1,NULL,NULL,NULL)
,(76,'Karjan','કરજણ','C.H.C. Karjan',19,'19011',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4260,1,NULL,NULL,NULL)
,(77,'Bharuch               ','ભરુચ','DTC bharuch',21,'21004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4093,1,NULL,NULL,NULL)
,(78,'Jambusar','જંબુસર','C.H.C.  Jambusar',21,'21001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4095,1,NULL,NULL,NULL)
,(79,'Vagra','વાગરા','C.H.C.  vagara',21,'21003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(80,'Hansot','હાંસોટ','Fp Centre Hansot',21,'21007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(81,'Zaghadia -T','ઝગડિયા','C.H.C.  Zaghadia',21,'21005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4096,1,NULL,NULL,NULL)
,(82,'Valia-T','વાલીયા','Traning hall valia',21,'21008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4098,1,NULL,NULL,NULL)
,(83,'Tilakvada-T','તિલકવાડા','C.H.C.  Tilakvada',20,'20001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4178,1,NULL,NULL,NULL)
,(84,'Nandod- T','નાંદોદ','J.P.Building Rajpipla',20,'20002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4176,1,NULL,NULL,NULL)
,(85,'Dediyapada-T','ડેડીયાપાડા','C.H.C.  Dediyapada',20,'20003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4175,1,NULL,NULL,NULL)
,(86,'Sagbara-T','સાગબારા','C.H.C.  sagbara',20,'20004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4177,1,NULL,NULL,NULL)
,(87,'Fatehpura-T','ફતેપુરા','C.H.C.  Fatehpura',18,'18001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4114,1,NULL,NULL,NULL)
,(88,'Zalod-T','ઝાલોદ','C.H.C.  Zalod',18,'18002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(89,'Limkheda -T','લીમખેડા','C.H.C.  Limkheda',18,'18003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4117,1,NULL,NULL,NULL)
,(90,'Dahod -T','દાહોદ','DTC Dahod',18,'18004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4111,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(91,'Garbada-T','ગરબડા','C.H.C.  Garbada',18,'18005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4115,1,NULL,NULL,NULL)
,(92,'Devgadh Baria -T','દેવગઢબારીયા','C.H.C.  Devgadh Baria',18,'18006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4112,1,NULL,NULL,NULL)
,(93,'Dhanpur-T','ધાનપુર','C.H.C.  Dhanpur',18,'18007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4113,1,NULL,NULL,NULL)
,(94,'Lunavada','લુણાવાડા','Cottege Hosp.Lunavada',32,'32004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4191,1,NULL,NULL,NULL)
,(95,'Kadana-T','કડાણા','C.H.C.  Kadana',32,'32002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4188,1,NULL,NULL,NULL)
,(96,'Santrampur-T','સંતરામપુર','State Hosp. Santrampur',32,'32003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4193,1,NULL,NULL,NULL)
,(97,'Sahera','શેહરા','P.H.C .Sahera',17,'17005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4194,1,NULL,NULL,NULL)
,(98,'Morva hadaff','મોરવા (હડફ)','P.H.C. Morva Hadaff',17,'17006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4192,1,NULL,NULL,NULL)
,(99,'Ghodhara-T','ગોધરા','PP Unit Ghodhara',17,'17007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4185,1,NULL,NULL,NULL)
,(100,'Kaalol-T','ક઼ાલોલ','C.H.C.  Kaalol',17,'17008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4189,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(101,'Halol -T','હાલોલ','C.H.C.  Halol',17,'17010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4186,1,NULL,NULL,1)
,(102,'Ghoghamba-T','ઘોઘંબા','C.H.C.  Ghoghamba',17,'17009',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4184,1,NULL,NULL,NULL)
,(103,'Olpad-T','ઓલપાડ','C.H.C.  Olpad',22,'22001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4239,1,NULL,NULL,NULL)
,(104,'Choryasi-T','ચોર્યાસી','New.Hosp.Choryasi',22,'22010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4233,1,NULL,NULL,NULL)
,(105,'Palsana-T','પલસાણા','C.H.C.  Palasana',22,'22011',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4240,1,NULL,NULL,NULL)
,(106,'Kamrej -T','કામરેજ','C.H.C. Kamrej',22,'22008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4234,1,NULL,NULL,NULL)
,(107,'Bardoli- T','બારડોલી','C.H.C.  Bardoli',22,'22012',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4232,1,NULL,NULL,NULL)
,(108,'Valod -T','વલોદ','C.H.C.   Valod',26,'26014',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4245,1,NULL,NULL,NULL)
,(109,'Mandavi - T','માંડવી','C.H.C.   Mandvi',22,'22007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4236,1,NULL,NULL,NULL)
,(110,'Mangrol','માંગરોલ','C.H.C.   mangrol',22,'22002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(111,'Vyara- T   ','વ્યારા','C.H.C.   Vyara',26,'26013',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4246,1,NULL,NULL,NULL)
,(112,'Songadh-T','સોનગઢ','C.H.C.   Songadh',26,'26006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4241,1,NULL,NULL,NULL)
,(113,'Mahuva - T','મહુવા','C.H.C.   Mahuva',22,'22015',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4235,1,NULL,NULL,NULL)
,(114,'Nizar- T ','નિઝર','C.H.C.  NIZAR',26,'26004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4238,1,NULL,NULL,NULL)
,(115,'Navsari','નવસારી','Leporesy Hosp.Navsari.',24,'24001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4182,1,NULL,NULL,NULL)
,(116,'Jalapore','જલાલપોર','Lep.Clnic Jalapore',24,'24002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4181,1,NULL,NULL,NULL)
,(117,'Gandevi','ગણદેવી','Icds block Gandevi',24,'24003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4180,1,NULL,NULL,NULL)
,(118,'Chikhali-T','ચીખલી','C.H.C.   Chikhali',24,'24004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4179,1,NULL,NULL,NULL)
,(119,'Vansada-T  ','વાંસદા','Cottege.Hosp.Vansada',24,'24005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4183,1,NULL,NULL,NULL)
,(120,'Valsad','વલસાડ','Dist.Traning  centre Valsad',25,'25001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4273,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(121,'Pardi-T','પારડી','Phc Orvad',25,'25003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4271,1,NULL,NULL,NULL)
,(122,'Umargam -T','ઉમરગામ','C.H.C.   Umargam',25,'25005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4272,1,NULL,NULL,NULL)
,(123,'Dharampur-T','ધરમપુર','DTC  Dharampur',25,'25002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4269,1,NULL,NULL,NULL)
,(124,'Kaprada-T ','કપરાડા','P.H.C. Kaprada',25,'25004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4270,1,NULL,NULL,NULL)
,(125,'Bhavnagar','ભાવનગર ','DTC Bhavnagar',14,'14005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(126,'Talaja','તળાજા','C.H.C.   Talaja',14,'14010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4107,1,NULL,NULL,NULL)
,(127,'Mahuva','મહુવા','Traning cetnre.Mahuva',14,'14011',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4104,1,NULL,NULL,NULL)
,(128,'Palitana','પાલીતાણા','PPUnit Palitana',14,'14009',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(129,'Botad','બોટાદ','C.H.C.   Botad',30,'30001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(130,'Vallabhipur','વલ્લભીપુર','FP Build.Vallabhipur',14,'14002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(131,'Sihor','શીહોર','C.H.C.    Sihor',14,'14007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4106,1,NULL,NULL,1)
,(132,'Manavadar','માણાવદર','C.H.C.   Manavadar',12,'12001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
,(133,'Keshod','કેશોદ','C.H.C.   Keshod',12,'12007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
,(134,'Junagadh','જુનાગઢ','Gen.Hosp,Junagadh',12,'12003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4133,1,NULL,NULL,NULL)
,(135,'Visavadar','વિસાવદર','C.H.C.   Visavadar',12,'12005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(136,'Malia-Hatina','માળિયા','C.H.C.   Malia-hatina',12,'12009',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4136,1,NULL,NULL,NULL)
,(137,'Talala','તલાલા','C.H.C.    Talala',29,'29010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4142,1,NULL,NULL,NULL)
,(138,'Veraval','વેરાવળ','Gen.Hosp.Veraval',29,'29011',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(139,'Kodinar','કોડીનાર','C.H.C.   Kodinar',29,'29013',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4135,1,NULL,NULL,NULL)
,(140,'Una','ઉના','C.H.C.   Una',29,'29014',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4143,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(141,'Mangrol','માંગરોળ','Chc Mangrol',12,'12008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4138,1,NULL,NULL,NULL)
,(142,'Kukavav','કુંકાવાવ વડિયા','C.H.C.   Kukavav',13,'13001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
,(143,'Dhari','ધારી','C.H.C.   Dhari',13,'13007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(144,'Lathi','લાઠી','C.H.C.   Lathi',13,'13003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(145,'Jafrabad','જાફરાબાદ','C.H.C.   Jafrabad',13,'13010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(146,'Savarkundla','સાવરકુંડલા','C.H.C.   savarkundla',13,'13008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4070,1,NULL,NULL,1)
,(147,'Amreli','અમરેલી','DTC Amreli',13,'13005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4060,1,NULL,NULL,NULL)
,(148,'Babara','બાબરા','C.H.C.   babra',13,'13002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4061,1,NULL,NULL,NULL)
,(149,'Porbandar','પોરબંદર','L C U Porbandar',11,'11001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4203,1,NULL,NULL,NULL)
,(150,'Kutiyana','કુતિયાણા','C.H.C.   kutiyana',11,'11003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(151,'Wankaner','વાંકાનેર','C.H.C.   Malia-Miyana',28,'28004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4218,1,NULL,NULL,NULL)
,(152,'Morbi','મોરબી','A DTC Morbi',28,'28002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4213,1,NULL,NULL,NULL)
,(153,'Rajkot','રાજકોટ','DTC Rajkot',9,'9006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4215,1,NULL,NULL,NULL)
,(154,'Jasdan','જસદણ','C.H.C.   Jasadan',9,'9009',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4208,1,NULL,NULL,NULL)
,(155,'Gondal','ગોંડલ','Civil Hosp.Gondal',9,'9010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4206,1,NULL,NULL,NULL)
,(156,'Dhoraji','ધોરાજી','Gen.Hosp.Dhoraji',9,'9013',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4205,1,NULL,NULL,NULL)
,(157,'Jetpur','જેતપુર','C.H.C.   Jetpur',9,'9014',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4209,1,NULL,NULL,NULL)
,(158,'Okhamandal','દ્વારકા','C.H.C.  Dharka',27,'27001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(159,'Khambhaliya','ખંભાળિયા','Gen.Hosp.Khambhaliya',27,'27002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4129,1,NULL,NULL,NULL)
,(160,'Jamnagar','જામનગર','Malaria office Jamnagar',10,'10003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4125,1,NULL,NULL,1)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(161,'Jodia','જોડીયા','C.H.C.   Jodia',10,'10004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
,(162,'Kalavad','કાલાવાડ','C.H.C.    Kalavad',10,'10006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4127,1,NULL,NULL,1)
,(163,'Lalpur','લાલપુર','C.H.C.    lalpur',10,'10007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
,(164,'Jamjodhpur','જામજોધપુર','C.H.C.    jamjodhpur',10,'10010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4124,1,NULL,NULL,1)
,(165,'Bhuj','ભૂજ','Disp.Madhapur,Taluka-Bhuj',1,'1005',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4149,1,NULL,NULL,1)
,(166,'Bhachau','ભચાઉ','C.H.C.    Bhachau',1,'1003',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4148,1,NULL,NULL,NULL)
,(167,'Anjar','અંજાર','C.H.C.    Anjar',1,'1004',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(168,'Rapar','રાપર','C.H.C.    Rapar',1,'1002',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4155,1,NULL,NULL,NULL)
,(169,'Nakhatrana','નખત્રાણા','C.H.C.    Nakhatrana',1,'1006',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4154,1,NULL,NULL,1)
,(170,'Mandvi','માંડવી','C.H.C.    Mandvi',1,'1008',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(171,'Abdasa','અબડાસા','C.H.C.   Naliya, Taluka - Abdasa',1,'1007',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,1)
,(172,'Ahwa','Ahwa','-',23,'23001',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(174,'Malpur','Malpur','CHC Malpur',31,'31012',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(175,'Dhansura','Dhansura','CHC Dhansura',31,'31011',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(176,'Surat','Surat','UHC Surat',301,'22009',1,'2011-01-01 00:00:00.000',NULL,NULL,1,4242,1,NULL,NULL,NULL)
,(177,'Unchhal','Unchhal','CHC Unchhal',26,'26005',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(178,'Barwala','Barwala','Barwala',30,'30010',1,'2011-01-01 00:00:00.000',NULL,NULL,1,NULL,0,NULL,NULL,NULL)
,(179,'Lakhni','લાખણી','Lakhni',2,'2013',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(180,'Suigam','સુઈગામ','Suigam',2,'2014',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(181,'Muli','મૂળી','Muli',8,'8006',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(182,'Lakhtar','લખતર','Lakhtar',8,'8004',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
,(183,'Chuda','ચુડા','Chuda',8,'8009',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
,(184,'Sojitra','સોજિત્રા','Sojitra',15,'15002',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(185,'Vinchhiya','વિંછીયા','Vinchhiya',9,'9015',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(186,'Thangadh','થાનગઢ','Thangadh',8,'8011',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(187,'Poshina','પોશિના','Poshina',5,'5014',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(188,'Bhanvad','ભાણવડ','Bhanvad',27,'27009',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(189,'Vaghai','વાઘાઈ','Vaghai',23,'23002',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(190,'Subir','સુબિર','Subir',23,'23003',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(191,'Shankheshwar','શંખેશ્વર','Shankheshwar',3,'3009',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(192,'Sutrapada','સુત્રાપાડા','Sutrapada',29,'29012',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(193,'Vanthali','વંથલી','Vanthali',12,'12002',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(194,'Mendarda','મેંદરડા','Mendarda',12,'12006',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(195,'Bhesan','ભેંસાણ','Bhesan',12,'12004',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
,(196,'Harij','હારીજ','Harij',3,'3006',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(197,'Khergam','ખેરગામ','Khergam',24,'24006',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(198,'Bodeli','બોડેલી','Bodeli',33,'33009',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(199,'Desar','દેસર','Desar',19,'19014',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(200,'Dholera','ધોલેરા','Dholera',7,'7013',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(201,'Netrang','નેત્રંગ','Netrang',21,'21009',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(203,'Jesar','જેસર','Jesar',14,'14013',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(204,'Garudeshwar','ગરુડેશ્વર','Garudeshwar',20,'20005',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(205,'Saraswati','સરસ્વતી','Saraswati',3,'3010',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(206,'Ghandhidham','ગાંધીધામ','Ghandhidham',1,'1010',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(207,'Jotana','જોટાણા','Jotana',4,'4010',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(208,'Anklav','આંકલાવ','Anklav',15,'15008',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(209,'Ghogha','ઘોઘા','Ghogha',14,'14006',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(210,'Umrala','ઉમરાળા','Umrala',14,'14004',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(211,'Jamkandorna','જામકંડોરણા','Jamkandorna',9,'9011',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(212,'Kheralu','ખેરાલુ','Kheralu',4,'4002',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(213,'Bhabhar','ભાભર','Bhabhar',2,'2011',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(214,'Amod','આમોદ','Amod',21,'21002',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(215,'Anklesvar','અંકલેશ્વર','Anklesvar',21,'21006',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(216,'Detroj','દત્રોજ','Detroj',7,'7002',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(217,'Mandal','માંડલ','Mandal',7,'7001',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(218,'Bagsara','બગસરા','Bagsara',13,'13006',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(219,'Khambha','ખંભા','Khambha',13,'13009',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(220,'Liliya','લીલીયા','Liliya',13,'13004',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(221,'Rajula','રાજુલા','Rajula',13,'13011',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(222,'Kalyanpur','કલ્યાણપુર','Kalyanpur',27,'27008',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(223,'Vapi','વાપી','Vapi',25,'25006',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(224,'Kotda Sangani','કોટડા સાંગાણી','Kotda Sangani',9,'9008',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(225,'Paddhari','પડધરી','Paddhari',9,'9005',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(226,'Lodhika','લોધિકા','Lodhika',9,'9007',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(227,'Mundra','મુંદ્રા','Mundra',1,'1009',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(228,'Lakhpat','લખપત','Lakhpat',1,'1001',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(229,'Upleta','ઉપલેટા','Upleta',9,'9012',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(230,'Dhrol','ધ્રોલ','Dhrol',10,'10005',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
,(231,'Gadhada','ગઢડા','Gadhada',30,'30003',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(232,'Ranpur','રાણપુર','Ranpur',30,'30009',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(233,'Gariadhar','ગારીયાધાર','Gariadhar',14,'14008',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1)
,(234,'Ranavav','રાણાવાવ','Ranavav',11,'11002',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(235,'Umarpada','ઉમરપાડા','Umarpada',22,'22003',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(236,'Sinor','સિનોર','Sinor',19,'19012',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(237,'Dolvan','Dolvan','Dolvan',26,'26016',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(238,'Kukarmunda','Kukarmunda','Kukarmunda',26,'26015',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(239,'Sanjeli','સંજેલી','Sanjeli',18,'18008',1,'2011-01-01 00:00:00.000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
,(240,'west zone','વેસ્ટ ઝોન','west zone',301,'22016',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(241,'north zone','નોર્થ ઝોન','north zone',301,'22017',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(242,'East Zone -A','ઇસ્ટ ઝોન- A','East Zone -A',301,'22018',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(243,'south zone','સાઉથ ઝોન','south zone',301,'22019',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(244,'south east zone','સાઉથ ઇસ્ટ ઝોન','south east zone',301,'22020',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(245,'Singvad','સિંગવડ','Singvad',18,'33010',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(246,'East Zone -B','ઇસ્ટ ઝોન - B','East Zone -B',301,'507',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(247,'Gandhinagar','Gandhinagar','Gandhinagar',303,'6005',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(248,'CENTRAL ZONE','મધ્ય ઝોન','CENTRAL ZONE',7005,'7014',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(249,'SOUTH ZONE','દક્ષીણ ઝોન','SOUTH ZONE',7005,'7015',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(250,'EAST ZONE','પૂર્વ ઝોન','EAST ZONE',7005,'7016',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(251,'NORTH WEST ZONE','ઉત્તર પશ્ચિમ ઝોન','NORTH WEST ZONE',7005,'7017',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(252,'WEST ZONE','પશ્ચિમ ઝોન','WEST ZONE',7005,'7018',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(253,'SOUTH WEST ZONE','દક્ષીણ પશ્ચિમ ઝોન','SOUTH WEST ZONE',7005,'7019',1,'2019-05-19 02:57:04.877',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(254,'Jamnagar City','જામનગર','Jamnagar City',305,'10011',1,'2019-05-19 11:40:45.430',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(255,'Junagadh City','જુનાગઢ','Junagadh City',307,'12015',1,'2019-05-19 11:40:45.430',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(256,'Bhavnagar City','ભાવનગર ','Bhavnagar City',306,'14012',1,'2019-05-19 11:40:45.430',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(257,'Vadodara City (North)','વડોદરા  RURAL','Vadodara City (North)',302,'19015',1,'2019-05-19 11:40:45.430',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(258,'Vadodara City (South)','વડોદરા  RURAL','Vadodara City (South)',302,'19016',1,'2019-05-19 11:40:45.430',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(259,'Vadodara City (East)','વડોદરા  RURAL','Vadodara City (East)',302,'19017',1,'2019-05-19 11:40:45.430',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(260,'Vadodara City (West)','વડોદરા  RURAL','Vadodara City (West)',302,'19018',1,'2019-05-19 11:40:45.430',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(261,'Rajkot','રાજકોટ','Rajkot',304,'9016',1,'2019-05-19 11:40:45.430',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
,(262,'Rajkot','રાજકોટ','Rajkot',304,'9017',1,'2019-05-19 11:40:45.430',NULL,NULL,1,NULL,1,NULL,NULL,NULL)
;
INSERT INTO anmol_Health_Block (BID,Name_E,Name_G,HQ,DCode,TCode,Created_by,Created_On,Modified_By,Modified_On,IsActive,MDDS_Code,IsVerified,IsRCH,HB_TypeID,SR_IMI) VALUES
(263,'Rajkot','રાજકોટ','Rajkot',304,'9018',1,'2019-05-19 11:40:45.430',NULL,NULL,1,NULL,1,NULL,NULL,NULL)