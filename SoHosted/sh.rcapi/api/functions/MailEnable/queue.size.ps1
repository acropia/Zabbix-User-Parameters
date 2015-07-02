# sh.rcapi\api\functions\MailEnable\queue.size.ps1 - Powershell
#
# Report file count for given MailEnable queue
#
# Author:  Jan Bouma | https://github.com/acropia/
If ( -Not (Test-Path Variable:RcApi)) {
	Write-Host "This script is not to be called directly.";
	Exit;
}

$logToScreen = $False;
$logToFile = $False;

Function ModuleMain($queueName) {
	Try {
		If ($queueName -ne "Inbound" -And $queueName -ne "Outgoing") {
			Throw "Parameter queueName not valid. Must be Inbound or Outgoing";
		}

		$queuePath = "C:\Program Files\Mail Enable\Queues\SMTP\$queue";
		If (-Not (Test-Path $queuePath)) {
			Throw "Queue Path not found";
		}

		$queueSize = @(Get-ChildItem $queuePath).Count;
		Return $queueSize;
	}
	Catch [Exception] {
		LogError $_.Exception.Message;
	}
}
