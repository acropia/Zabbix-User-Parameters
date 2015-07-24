# sh.rcapi\api\functions\process\stop.ps1 - Powershell
#
# Stop given Windows Process
#
# Author: Jan Bouma | https://github.com/acropia/
If ( -Not (Test-Path Variable:RcApi)) {
	Write-Host "This script is not to be called directly.";
	Exit;
}

$logToScreen = $True;
$logToFile = $True;

Function ModuleMain($processName) {
	Try {
		If ( -Not ($processName)) {
			Throw "Required parameter processName not given";
		}

		LogInfo "ProcessName: $processName"

		If ( -Not @(Get-Process | Where-Object { $_.ProcessName -eq $processName}).Length -gt 0) {
			Throw "Process $processName not found";
		}

		$processCount = @(Get-Process | Where-Object { $_.ProcessName -eq $processName}).Length;
		LogInfo "Current process count: $processCount";

		LogInfo "Stopping process..."
		Stop-Process -Name $processName -Force;

		LogInfo "Sleeping for 5 sec..."
		Start-Sleep 5;

		$processCount = @(Get-Process | Where-Object { $_.ProcessName -eq $processName}).Length;
		LogInfo "Current process count: $processCount";
		LogInfo "Module finished.";
	}
	Catch [Exception] {
		LogError $_.Exception.Message;
	}
}
