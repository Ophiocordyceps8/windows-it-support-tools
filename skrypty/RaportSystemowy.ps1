<#
    .SYNOPSIS
        Informacje o systemie, RAM i CPU.
    .DESCRIPTION
        Zbiera informacje o systemie, RAM, CPU i Pamięci oraz zapisuje je do pliku tekstowego.
#>

[CMDletBinding()]
param ([string]$OutputFile)

if (-not $OutputFile) { $OutputFile = "$env:USERPROFILE\Desktop\Raport-Systemowy.txt" }

Write-Host "Zbieranie informacji o systemie..."

$os = Get-CimInstance -ClassName Win32_OperatingSystem
$computer = Get-CimInstance -ClassName Win32_ComputerSystem

$uptime = (Get-Date) - $os.LastBootUpTime

$cpu = Get-CimInstance -ClassName Win32_Processor

$totalRamGB = [math]::Round($computer.TotalPhysicalMemory / 1GB, 2)
$freeRamGB = [math]::Round([double]$os.FreePhysicalMemory / 1048576, 2) # Zamiana KB na GB
$usedRamGB = [math]::Round($totalRamGB - $freeRamGB, 2)
$topRam = Get-Process | Sort-Object WorkingSet -Descending | 
Select-Object -First 3 Name, @{Name="MB";Expression={[math]::Round($_.WorkingSet / 1MB, 2)}}

$diskC = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"
$totalDiskGB = [math]::Round($diskC.Size / 1GB, 2)
$freeDiskGB = [math]::Round($diskC.FreeSpace / 1GB, 2)
$usedDiskGB = [math]::Round($totalDiskGB - $freeDiskGB, 2)

$report = @"
Wyniki Raportu Systemowego:
------------------------------
Czas Raportu: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Uzytkownik: $($env:USERNAME)
Grupa: $($env:USERDOMAIN)
------------------------------
System operacyjny: $($os.Caption) $($os.Version)
Wersja systemu: $($os.BuildNumber)
------------------------------
Czas Pracy: $($uptime.Days) dni, $($uptime.Hours) godzin, $($uptime.Minutes) minut
------------------------------
CPU:   
 Model: $($cpu.Name)    
RAM:
    Calkowita: $totalRamGB GB
    Uzywane: $usedRamGB GB
    Wolne: $freeRamGB GB
    Procesy o najwyzszym zuzyciu pamieci:
        1. $($topRam[0].Name) - $($topRam[0].MB) MB
        2. $($topRam[1].Name) - $($topRam[1].MB) MB
        3. $($topRam[2].Name) - $($topRam[2].MB) MB
Dysk:
    Calkowita: $totalDiskGB GB
    Zuzyta: $usedDiskGB GB
    Wolne: $freeDiskGB GB
------------------------------
"@

Write-Host $report
$report | Out-File -FilePath $OutputFile -Encoding UTF8

Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("Raport zapisany w pliku: $OutputFile", "Raport Systemowy", [System.Windows.MessageBoxButton]::OK, 
[System.Windows.MessageBoxImage]::Information)
