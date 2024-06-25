# For Production

```
cd imtecho/ImtechoV2/imtecho-web/src/main/resources/documents/anmol

sudo wsimport -d /home/subhash/slamba/work/imtecho/imtecho/ImtechoV2/imtecho-web/src/main/java -p  com.argusoft.imtecho.anmol.wsdl  -verbose -b http://www.w3.org/2001/XMLSchema.xsd -b xsd.xjb https://rchrpt.nhm.gov.in/TRCH/?WSDL
```

# For Staging
```
cd imtecho/ImtechoV2/imtecho-web/src/main/resources/documents/anmol

sudo wsimport -d /home/subhash/slamba/work/imtecho/imtecho/ImtechoV2/imtecho-web/src/main/java -p  com.argusoft.imtecho.anmol.wsdl  -verbose -b http://www.w3.org/2001/XMLSchema.xsd -b xsd.xjb https://rchrpt.nhm.gov.in/TRCH_rel/?WSDL
```
For the database side:
```
update anmol_location_mapping set district_code = '18';
update anmol_location_mapping set taluka_code = '0835';
update anmol_location_mapping set village_code = '22328';

update anmol_location_mapping set health_facility_code = '403';
update anmol_location_mapping set health_subfacility_code = '2049';
update anmol_location_mapping set health_block_code = '264';
update anmol_location_mapping set health_facility_type = '1';

update anmol_location_mapping set asha_id = '236';
update anmol_location_mapping set anm_id = '234';
update anmol_location_mapping set state_code = '95';
```

### Login Details
```https://rchrpt.nhm.gov.in
State : Test-AP
UserName : nic02
Password :```
