﻿clear
$moduleName = "MSOnline"
write-host -ForegroundColor DarkGreen `
("[+] Check for module {0}" -f $moduleName)

if (Get-Module -ListAvailable -Name $moduleName) 
{
    Write-Host -ForegroundColor DarkGreen "[+] Module exists"
} 
else 
{
    Write-Host -ForegroundColor DarkRed "[-] Module is missing!"
    Write-Host -ForegroundColor DarkYellow ("[.] Installing module {0}..." -f  $moduleName )
    Install-Module -AllowClobber -Force $moduleName
}

Write-Host
Write-Host -ForegroundColor DarkGreen "[+] Connecting to Online services"
Connect-MsolService

if ($?)
{
    Write-Host -ForegroundColor DarkGreen "[+] Connected"

    $domainName = $(Get-MsolDomain | Where-Object {($_.Name -like '*onmicrosoft.com*') `
                   -and ($_.Name -notlike '*mail.onmicrosoft.com*') }).Name
    
    $filename = "SubscriptionGUID_{0}_{1}.csv" -f $domainName, $(get-date -f yyyyMMdd)
    $exportPath = "{0}\Desktop\{1}" -f $home, $filename

    Get-MsolAccountSku | Select-Object -ExpandProperty SubscriptionIds `
        -Property SkuPartNumber,AccountSkuId,ActiveUnits,ConsumedUnits | Export-Csv -NoTypeInformation `
        -Delimiter ";" -Path $exportPath 

    notepad.exe $exportPath 

    Write-Host -ForegroundColor DarkGreen ("[+] File saved in {0}" -f $exportPath)
}
else
{
    Write-Host -ForegroundColor DarkRed "[+] Connection failed" 
}
"Press key to exit.."
Read-Host

