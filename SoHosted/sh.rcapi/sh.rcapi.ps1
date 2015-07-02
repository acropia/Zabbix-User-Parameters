# sh.rcapi.ps1 - Powershell
#
# SoHosted Remote Command API for Zabbix Agent
#
# Author: Jan Bouma | https://github.com/acropia/
$RcApi = 0.1;

$function = $args[0];
$param1 = $args[1];

If ($args.Length -eq 0) {
	Write-Host "SoHosted Remote Command API for Zabbix Agent"
	Write-Host "";
	Write-Host "  Usage: sh.rcapi.ps1 Function Param1 [Param2]";
	Write-Host "";
	Write-Host "Functions:"
	Write-Host "  me.queue.size             Return active queue size"
	Write-Host "      QueueName             - Inbound or Outbound"
	Write-Host "  process.grouped.count     Count grouped processes"
	Write-Host "      Limit=5               - Limit result to top <Limit>"
	Write-Host "  process.iops.top          Process disk IO"
	Write-Host "      Limit=5               - Limit result to top <Limit>"
	Write-Host "  service.restart           Restart a Windows service"
	Write-Host "      ServiceName           - Windows Service Name"
	Write-Host "";
	Exit;
}
Try {
	$scriptPath = Split-Path $MyInvocation.MyCommand.Path;
	. (Join-Path $scriptPath 'api\bootstrap.ps1');
	
	If ($function -eq "service.restart") {
		. (Join-Path $scriptPath 'api\functions\service\restart.ps1');
	}
	ElseIf ($function -eq "me.queue.size") {
		. (Join-Path $scriptPath 'api\functions\MailEnable\queue.size.ps1');
	}
	ElseIf ($function -eq "process.grouped.count") {
		. (Join-Path $scriptPath 'api\functions\process\grouped.count.ps1');
	}
	ElseIf ($function -eq "process.iops.top") {
		. (Join-Path $scriptPath 'api\functions\process\iops.top.ps1');
	}
	Else {
		Throw "Function $function is not a registered SoHosted Zabbix API function";
	}

	LogInfo "sh.rcapi.ps1 ------------------------------------------";
	$output = ModuleMain($param1);
	Return $output;
}
Catch [Exception] {
	Write-Host "Exception: " $_.Exception.Message;
}
