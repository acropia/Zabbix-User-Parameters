# sh.me.queue.size.ps1 - Powershell
#
# Report file count for given MailEnable queue.
# Script is used as a Zabbix User Parameter
# 
# Usage: sh.me.queue.size.ps1 Queue
#  - Queue: Inbound, Outgoing
#
# Author: Jan Bouma | https://github.com/acropia/
if ($args.Length -eq 0) {
    Write-Host "Usage: sh.me.queue.size.ps1 Direction";
    Exit;
}
try {
    $queue = $args[0];
    if ($queue -ne "Inbound" -And $queue -ne "Outgoing") {
        Throw "Parameter not valid";
    }

    $queuePath = "C:\Program Files\Mail Enable\Queues\SMTP\$queue";
    if (-Not (Test-Path $queuePath)) {
        Throw "Queue Path not found";
    }

    $queueSize = @(Get-ChildItem $queuePath).Count;
    Write-Host $queueSize;
}
catch [Exception] {
#    Write-Host $_.Exception.Message;
    Write-Host 0;
}
