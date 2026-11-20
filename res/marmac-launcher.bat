@echo off
:: Questo batch viene estratto insieme all'app nella cartella temporanea.
:: Lancia rustdesk.exe, aspetta la chiusura, poi rimuove tutta la cartella.
start /wait "" "%~dp0rustdesk.exe"
:: Pulizia: cancella la cartella di estrazione
rd /s /q "%~dp0"
