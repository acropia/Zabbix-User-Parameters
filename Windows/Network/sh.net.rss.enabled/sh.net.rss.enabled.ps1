# sh.net.rss.enabled.ps1 - Powershell
#
# Report if given Network Adapter has the Receive Side Scaling option enabled.
# Script is used as a Zabbix User Parameter
#
# Author: Jan Bouma | https://github.com/acropia/
if ($args.Length -eq 0) {
    Write-Host "Usage: sh.net.rss.enabled.ps1 NetworkAdapterName";
    Exit;
}
try {
    $rssEnabled = $(Get-NetAdapterRss -Name $args[0] -ErrorAction Stop).Enabled;
    if ($rssEnabled -eq "True") {
        Write-Host 1;
        Exit;
    }
}
catch [Exception] {}
Write-Host 0;
