<#
    .Synopsis
        Podstawowa Diagnostyka Sieci.
    .DESCRIPTION
        Zbiera infomracje na temat adresu IP, Maski, Gateway, DNS oraz testuje lacznosc z siecia.
#>

[CMDletBinding()] 
param ([string]$OutputFile)

if (-not $OutputFile) { $OutputFile = "$env:USERPROFILE\Desktop\Raport-Sieciowy.txt" }

Write-Host "Zbieranie informacji o sieci..."

$activeRoute = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Sort-Object RouteMetric | Select-Object -First 1
$interfaceIndex = $activeRoute.InterfaceIndex
$gateway = $activeRoute.NextHop

$ipConfig = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetAdapter | Where-Object Status -eq "Up" |
Select-Object -ExpandProperty InterfaceIndex) -ErrorAction SilentlyContinue | Select-Object IPAddress, InterfaceAlias

$dnsServers = (Get-DnsClientServerAddress -InterfaceIndex $interfaceIndex -AddressFamily IPV4 -ErrorAction SilentlyContinue).ServerAddresses

$pingGateway = if ($gateway) { Test-Connection -ComputerName $gateway -Count 1 -Quiet} else { $false }
$pingInternet = Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet

$report = @"
------------------------------
Czas Raportu: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Uzytkownik: $($env:USERNAME)
Grupa: $($env:USERDOMAIN)
------------------------------
Interfejs Sieciowy: $($ipConfig.InterfaceAlias)
Adres IP: $($ipConfig.IPAddress)
Gateway: $gateway
DNS: $($dnsServers -join ", ")
------------------------------
Test lacznosci:
    Gateway Ping ($gateway): $(if($pingGateway) { "Polaczenie Poprawne" } else { "Blad Polaczenia" })
    Internet Ping (8.8.8.8): $(if($pingInternet) { "Polaczenie Poprawne" } else { "Blad Polaczenia" })
------------------------------
"@

Write-Host $report
$report | Out-File -FilePath $OutputFile -Encoding UTF8

Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("Raport zapisany w pliku: $OutputFile", "Raport Sieciowy", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
