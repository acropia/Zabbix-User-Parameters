# sh.rcapi\api\functions\process\iops.top.ps1 - Powershell
#
# Return a list of running processes ordered by disk IO per second
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

		$samples = (Get-Counter -Counter "\Process(*)\IO Data Operations/sec" -SampleInterval 1 -ErrorAction SilentlyContinue).CounterSamples |
			Where-Object { $_.CookedValue -gt 0 } |
			Where-Object { $_.InstanceName -ne "_total" } |
			Sort-Object -Descending "CookedValue" |
			Select-Object InstanceName, @{Name="IOPerSec";Expression={[math]::Round($_.CookedValue,0)}} -First $limit;

		$output = '';
		$output += "<style>`n";
		$output += "table.screen_view table.proc_grouped { border-collapse: collapse; }`n";
		$output += "table.screen_view table.proc_grouped th { font-family: Verdana; font-size: 11px; padding: 1px 4px; text-align: left; }`n";
		$output += "table.screen_view table.proc_grouped td { border-top: 1px solid #CCC; font-family: Verdana; font-size: 11px; padding: 1px 8px; text-align: left; }`n";
		$output += "</style>`n";
		$output += "<table class='proc_grouped'>`n";
		$output += "<thead><tr><th>InstanceName</th><th>IOPS</th></thead>`n";
		$output += "<tbody>`n";
		$samples | Foreach-Object {
			$output += "<tr><td>" + $_.InstanceName + "</td><td>" + $_.IOPerSec + "</td></tr>`n";
		}
		$output += "</tbody>`n";
		$output += "</table>";
		Return $output;
	}
	Catch [Exception] {
		LogError $_.Exception.Message;
	}
}
