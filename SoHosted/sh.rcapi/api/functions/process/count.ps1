# sh.rcapi\api\functions\process\count.ps1 - Powershell
#
# Count running processes filtered by given name
#
# Author:  Jan Bouma | https://github.com/acropia/
If ( -Not (Test-Path Variable:RcApi)) {
	Write-Host "This script is not to be called directly.";
	Exit;
}

$logToScreen = $False;
$logToFile = $False;

Function ModuleMain($processName) {
	Try {
		If ( -Not ($processName)) {
			Throw "Required parameter processName not given";
		}

		$count = @(Get-Process  |
			Where-Object { $_.ProcessName -eq "perl"}).Count;

		Return $count;
	}
	Catch [Exception] {
		LogError $_.Exception.Message;
	}
}
