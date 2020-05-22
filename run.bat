@ECHO OFF
PowerShell.exe -Command "& {Start-Process PowerShell.exe -ArgumentList '-ExecutionPolicy Bypass -File ""%~dp0Get-SubscriptionIds.ps1""' -Verb RunAs}"