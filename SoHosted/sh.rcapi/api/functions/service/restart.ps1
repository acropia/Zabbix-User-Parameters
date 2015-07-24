# sh.rcapi\api\functions\service\restart.ps1 - Powershell
#
# Restart given Windows Service
#
# Author: Alexander Mulder
# Contributor: Jan Bouma | https://github.com/acropia/
If ( -Not (Test-Path Variable:RcApi)) {
	Write-Host "This script is not to be called directly.";
	Exit;
}

$logToScreen = $True;
$logToFile = $True;

Function GetServiceStatus($serviceName) {
	$serviceStatus = Get-Service -Name "*$serviceName*" -ErrorAction SilentlyContinue | Select -ExpandProperty Status;
	Return $serviceStatus;
}

Function ModuleMain($serviceName) {
	Try {
		If ( -Not ($serviceName)) {
			Throw "Required parameter serviceName not given";
		}

		$stopped = $False;
		$serviceName = $serviceName -Replace "_DOLLAR_", "$";
		LogInfo "ServiceName: $serviceName"

		If ( -Not @(Get-Service | Where-Object { $_.Name -eq $serviceName}).Length -eq 1) {
			Throw "Service $serviceName not found";
		}

		$serviceStatus = GetServiceStatus($serviceName);
		LogInfo "Current service status: $serviceStatus";

		LogInfo "Stopping service..."
		Stop-Service $serviceName -Force;

		$serviceStatus = GetServiceStatus($serviceName);
		LogInfo "Service status: $serviceStatus";

		If ($serviceStatus -eq "Stopped") {
			$stopped = $True;
		}

		LogInfo "Starting service..."
		Start-Service $serviceName;

		$serviceStatus = GetServiceStatus($serviceName);
		LogInfo "Service status: $serviceStatus";

		If ($serviceStatus -eq "Running") {
			If ($stopped -eq $True) {
				LogInfo "Service restart successful";
			}
			Else {
				LogError "Service restart failed. Service has not been in Stopped stated!";
			}
		}
		Else {
			LogError "Service restart failed!";
		}
	}
	Catch [Exception] {
		LogError $_.Exception.Message;
	}
}
