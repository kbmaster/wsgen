# ws shit machine (prototype)
Publish dummy php webservice from wsdl file.

Requires Zend Framework 1.12.5

# How it works ?

Write your wsdl file and edit the wsgen.cnf 

**wsgen_web_root**= /your/web/root

**wsgen_srv_name**= my_service_name

**wsgen_srv_conf_dir** = /etc

**wsgen_srv_log_dir**= /var/log

**wsgen_srv_wsdl**= my_wsdl.wsdl

then **Make** and the magic happens.






