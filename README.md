# Proste skrypty do diagnostyki
Zestaw skryptów w PowerShellu do szybkiej diagnostyki komputera oraz sieci.

## Co robi?
**`RaportSystemowy.ps1`** przedstawia podstawowe informacje o systemie, takie jak:
  - Wersja systemu
  - Nazwa użytkownika
  - Nazwa grupy
  - Czas działania (uptime)
  - Nazwa procesora
  - Informacje o wykorzystaniu RAM-u
  - Informacje o wykorzystaniu dysku


**`DiagnostykaSieci.ps1`** przedstawia informacje o sieci, takie jak:
  - Nazwa użytkownika
  - Nazwa grupy
  - Nazwa interfejsu sieciowego
  - Adres IP
  - Gateway (brama domyślna)
  - DNS
  - Test łączności z internetem

Po wykonanej diagnozie wynik raportu zapisze się automatycznie w pliku tekstowym na pulpicie.

## Specyfikacja
**Język:** PowerShell
**System:** Windows

## Jak używać?
Wystarczy otowrzyć terminal w folderze gdzie skrypt się znajduję i zastosować komendę
    .\RaportSystemowy.ps1
Lub
    .\DiagnostykaSieci.ps1

Drugą możliwością jest jest kliknięcie prawym przyciskiem na skrypt oraz wybranie opcji która uruchamia program z wykorzystaniem PowerShell


## Troubleshooting (Rozwiązywanie problemów)
**Błąd braku uprawnień:** Domyślnie system Windows blokuje uruchamianie lokalnych skryptów. Jeżeli chcesz włączyć skrypt bez praw administratora, wystarczy wpisać w PowerShellu poniższą komendę, która zezwoli na uruchamianie skryptów:
 
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser 