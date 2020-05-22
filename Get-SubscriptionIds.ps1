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
    Install-Module -AllowClobber -Force MSOnline
}

Import-Module -Name $moduleName

Write-Host -ForegroundColor DarkGreen "[+] Connecting to Online services"
if (Connect-MsolService)
{
    Write-Host -ForegroundColor DarkGreen "[+] Connected"
    
    $filename = "SubscriptionGUID_{0}_{1}.csv" -f $(Get-MsolDomain).Get(0).Name, $(get-date -f yyyy-MM-dd)
    $exportPath = "{0}\Desktop\{1}" -f $home, $filename

    Get-MsolAccountSku | Select-Object -ExpandProperty SubscriptionIds `
        -Property SkuPartNumber,AccountSkuId,ActiveUnits,ConsumedUnits | Export-Csv -NoTypeInformation `
        -Delimiter ";" -Path $exportPath 

    notepad.exe $exportPath 

    Write-Host -ForegroundColor DarkGreen ("[+] File saved in {0}" -f $exportPath)
}
"Press key to exit.."
Read-Host
