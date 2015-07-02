# sh.rcapi\api\functions\process\grouped.count.ps1 - Powershell
#
# Return a grouped list of running processes
#
# Author: Jan Bouma | https://github.com/acropia/
If ( -Not (Test-Path Variable:RcApi)) {
	Write-Host "This script is not to be called directly.";
	Exit;
}

$logToScreen = $False;
$logToFile = $False;

Function ModuleMain($limit) {
	Try {
		If ( -Not ($limit)) {
			$limit = 5;
		}

		$processes = Get-Process | Group-Object ProcessName | Sort-Object Count -Desc | Select-Object -First $limit;

		$output = '';
		$output += "<style>`n";
		$output += "table.screen_view table.proc_grouped { border-collapse: collapse; }`n";
		$output += "table.screen_view table.proc_grouped th { font-family: Verdana; font-size: 11px; padding: 1px 4px; text-align: left; }`n";
		$output += "table.screen_view table.proc_grouped td { border-top: 1px solid #CCC; font-family: Verdana; font-size: 11px; padding: 1px 8px; text-align: left; }`n";
		$output += "</style>`n";
		$output += "<table class='proc_grouped'>`n";
		$output += "<thead><tr><th>Count</th><th>ProcessName</th></thead>`n";
		$output += "<tbody>`n";
		$processes | Foreach-Object {
			$output += "<tr><td>" + $_.Count + "</td><td>" + $_.Name + "</td></tr>`n";
		}
		$output += "</tbody>`n";
		$output += "</table>";
		Return $output;
	}
	Catch [Exception] {
		LogError $_.Exception.Message;
	}
}
