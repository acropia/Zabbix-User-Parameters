# sh.rcapi\api\functions\process\ws.service.ps1 - Powershell
#
# Get Working Set of given service
#
# Author:  Jan Bouma | https://github.com/acropia/
If ( -Not (Test-Path Variable:RcApi)) {
	Write-Host "This script is not to be called directly.";
	Exit;
}

$logToScreen = $False;
$logToFile = $False;

Function ModuleMain($serviceName) {
	Try {
		If ( -Not ($serviceName)) {
			Throw "Required parameter serviceName not given";
		}

		$serviceName = $serviceName -Replace "_DOLLAR_", "`$";
		LogInfo "ServiceName: $serviceName";

		$wmiService = Get-WmiObject Win32_Service -Filter "Name LIKE '$serviceName'";
		$processId = $wmiService.ProcessID;
		LogInfo "ProcessId: $processId";

		$processMeasure = Get-Process |
			Where-Object { $_.Id -eq $processId } |
			Measure-Object WS -Sum;

		$sum = $processMeasure.Sum;
		Return $sum;
	}
	Catch [Exception] {
		LogError $_.Exception.Message;
	}
}
