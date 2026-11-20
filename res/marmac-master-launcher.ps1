# Launcher silenzioso per MarMac Remote (Master)
# Viene compilato in .exe da ps2exe nel workflow CI.
# Lancia rustdesk.exe dalla stessa cartella, aspetta la chiusura,
# poi cancella l'intera cartella temporanea di estrazione.

$dir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$exe = Join-Path $dir "rustdesk.exe"

$proc = Start-Process -FilePath $exe -WorkingDirectory $dir -PassThru
$proc.WaitForExit()

# Pulizia silenziosa
Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
