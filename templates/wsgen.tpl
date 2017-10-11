<?php
	require_once 'Zend/Loader/Autoloader.php';
	define('INI_FILE',"{:SRV_CNF:}");
	
	class {:SRV_NAME:}WS
	{
		private $config;
		private $server;
		private $db;
		

		public function {:SRV_NAME:}WS()
		{
			$this->bootStrap();
			$this->server = new SoapServer($this->config->wsdl,array("cache_wsdl"=>WSDL_CACHE_NONE));
			$this->server->setClass('{:SRV_NAME:}WS');
		}
		
		private function bootStrap()
		{
			Zend_Loader_Autoloader::getInstance()->setFallbackAutoloader(true);
			$this->config = new Zend_Config_Ini(INI_FILE, 'ws');
			
			
			if(!empty($_SERVER['HTTP_X_FORWARDED_HOST'])) 
				$_SERVER['SERVER_NAME'] = $_SERVER['HTTP_X_FORWARDED_HOST'];
			if(isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
				$_SERVER['HTTPS'] = "on";
			$HTTPS = isset($_SERVER["HTTPS"]) ? strtolower($_SERVER["HTTPS"]) : "";
			
			
			if($this->config->secure && $HTTPS != "on")
			{
				echo "Error de conexion SSL. Este servicio solo puede accederse con conexion segura y certificado cliente adecuado.";
				exit;
			}
			
			if(!empty($this->config->log))
			{ 
				$logger = new Zend_Log();
				$writer = new Zend_Log_Writer_Stream($this->config->log);
				$logger->addWriter($writer);
				Zend_Registry::set('logger',$logger);
			}	
		
		}

		
		public function run()
		{
			$rawHttp = (!empty($GLOBALS['HTTP_RAW_POST_DATA']))? $GLOBALS['HTTP_RAW_POST_DATA']: file_get_contents("php://input");

			$reqid = uniqid();
			$msglogIn  = "Request [$reqid] Cliente: [" . $_SERVER['REMOTE_ADDR']  . "] URL: [" . $_SERVER['REQUEST_URI'] . "] ";
			$msglogIn .= "Raw HTTP Data:\n" . $rawHttp . "\n";
						
			ob_start();
			try 
			{ 
				$this->server->handle(); 
			}
			catch (Exception $e) 
			{
				$this->server->fault('Sender', $e->getMessage());
			}
			
			$salida = ob_get_contents();
			$msglogOut  = "Response [$reqid] \n$salida\n\n";
			
			if(!empty($this->config->log))
			{
				$logger = Zend_Registry::get('logger');
				$logger->log($msglogIn, Zend_Log::INFO);
				$logger->log($msglogOut, Zend_Log::INFO);
			}
			
		}


		{:SRV_FUNC:}
			
}
	
	
	//======================================================================
	//======================================================================
	$ws = new {:SRV_NAME:}WS();
	$ws->run();

?>
