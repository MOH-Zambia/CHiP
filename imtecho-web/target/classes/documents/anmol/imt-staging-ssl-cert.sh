Generate certificate for https://www.sslforfree.com/


openssl pkcs12 -export -in certificate.crt -inkey private.key -name imtstaging.argusoft.com -out imtstaging-PKCS-12.p12


keytool -importkeystore -deststorepass q1w2e3R$ -destkeystore imtstaging.jks -srckeystore imtstaging-PKCS-12.p12 -srcstoretype PKCS12


keytool -import -alias bundle -trustcacerts -file ca_bundle.crt -keystore imtstaging.jks
