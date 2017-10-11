<?php
function processTypes($types)
{
	$T=array();

	foreach($types as &$type)
	{
    	$type=str_replace("\n","",$type);
	    preg_match('/struct\s*(.*)\s*\{\s*(.*)\s*}/',$type,$matches);
		$attr_type=explode(";",$matches[2]);
		unset($attr_type[count($attr_type)-1]);
		$T[trim($matches[1])]=array();

		foreach($attr_type as $pair)
		{
		   $attr=array_reverse(explode(" ",$pair));
		   $attr=array($attr[0]=>$attr[1]);
		   array_push($T[trim($matches[1])],$attr);
		}
	}

	return $T;
}

function getDummy($type,$types)
{
	if(!$types[$type])
	{
		return "0";	
	}
	else
	{
		$r=array();
		foreach($types[$type] as $attr)
		{
			foreach($attr as $k=>$v)
			$r[$k]=getDummy($v,$types);
		}	

		return $r;
	}
}

$ss=new SoapClient($argv[1]);
$methods=$ss->__getFunctions();
$Types= processTypes($ss->__getTypes());


foreach($methods as $method)
{
	preg_match('/(.*)\s(.*)\((.*)\s/',$method,$matches);
	$ret=var_export(getDummy($matches[1],$Types),true);
	$function="#	public function $matches[2](\$args)#
	{#
		/*your code here*/##
		
		/*Dummy return*/#
		return $ret;#
	}###";

	$function=str_replace(array('(',')','/','*','=',"'",'{','}'),array('\(','\)','\/','\*','\=',"\'",'\{','\}'),$function);

	echo "$function";
}

?>
