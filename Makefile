NAME		=$(shell cat wsgen.cnf | grep wsgen_srv_name | sed -e 's/wsgen_srv_name\s*=\s*//')
ROOT		=$(shell cat wsgen.cnf | grep wsgen_web_root | sed 's/wsgen_web_root\s*=\s*//')
CONF_DIR	=$(shell cat wsgen.cnf | grep wsgen_srv_conf_dir | sed -e 's/wsgen_srv_conf_dir\s*=\s*//' -e 's/\s//g')
CONF_DIR_ESC=$(shell echo "${CONF_DIR}" | sed -e 's|/|\\\/|g' -e 's/\s//g')
LOG_DIR		=$(shell cat wsgen.cnf | grep wsgen_srv_log_dir | sed 's/wsgen_srv_log_dir\s*=\s*//')
LOG_DIR_ESC =$(shell echo "${LOG_DIR}" | sed -e 's|/|\\\/|g' -e 's/\s//g')
WSDL		=$(shell cat wsgen.cnf | grep wsgen_srv_wsdl | sed 's/wsgen_srv_wsdl\s*=\s*//')
FUNC		=$(shell php wsgen.php ${WSDL})

publish:
	echo "$(CONF_DIR_ESC)---"
	mkdir $(ROOT)/$(NAME)
	cp $(WSDL) $(ROOT)/$(NAME)/$(WSDL)
	touch $(LOG_DIR)/$(NAME).log
	chown wwwrun:www  $(LOG_DIR)/$(NAME).log
	
	cat templates/wsgen.tpl | \
	sed  -e "s/{:SRV_NAME:}/$(NAME)/" \
	-e "s/{:SRV_CNF:}/$(CONF_DIR_ESC)\/$(NAME).ini/" \
	-e "s/{:SRV_FUNC:}/$(FUNC)/" \
	-e "s/#/\n/g" > $(ROOT)/$(NAME)/$(NAME).php 
	
	cat templates/wsgen.ini.tpl | \
	sed -e "s/{:SRV_WSDL:}/$(WSDL)/" \
	-e "s/{:SRV_LOG:}/$(LOG_DIR_ESC)\/$(NAME).log/" > $(CONF_DIR)/$(NAME).ini

#test:
	

clean:
		rm -Rf $(ROOT)/$(NAME)
		rm -f $(LOG_DIR)/$(NAME).log
		rm -f $(CONF_DIR)/$(NAME).ini
		rm ./test/*.xml
	
		
	
