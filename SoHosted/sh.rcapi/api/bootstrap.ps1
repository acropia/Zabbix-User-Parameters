# sh.rcapi\api\bootstrap.ps1 - Powershell
#
# Bootstrap the SoHosted Remote Command API for Zabbix Agent
#
# Author: Jan Bouma | https://github.com/acropia/
If ( -Not (Test-Path Variable:RcApi)) {
	Write-Host "This script is not to be called directly.";
	Exit;
}

$logPath = 'C:\appdata\Zabbix_Agent\log\sh.rcapi\';
If ( -Not (Test-Path($logPath))) {
	New-Item -ItemType Directory -Force -Path $logPath | Out-Null;
}

# Log debug info to screen (stdout)
$logToScreen = $False;

# Log debug info to file
$logToFile = $True;

. (Join-Path $scriptPath 'api\logger.ps1');
$logFile = GetLogFilePath($function);
