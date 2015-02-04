if ($args.Length -eq 0) {
    Write-Host "Usage: test.ps1 NetworkAdapterName";
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