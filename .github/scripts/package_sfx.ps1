# Crea un exe portable autoestraente dalla build Flutter Windows.
# Usa 7zSD.sfx (modulo "for installers" dell'LZMA SDK): estrae in %TEMP%,
# esegue RunProgram, attende la chiusura e cancella la cartella temporanea.
# Il 7z.sfx dell'installazione standard di 7-Zip NON legge il config
# (mostra solo "Estrai in..." e non avvia nulla), quindi non va usato.
param(
    [Parameter(Mandatory)] [string] $Title,
    [Parameter(Mandatory)] [string] $Output,
    [string] $BuildDir = "flutter\build\windows\x64\runner\Release",
    [string] $Icon = "res\icon.ico"
)
$ErrorActionPreference = "Stop"
$sevenZip = "C:\Program Files\7-Zip\7z.exe"
$work = Join-Path $env:RUNNER_TEMP "sfx"
New-Item -ItemType Directory -Force -Path $work | Out-Null

$sdk = Join-Path $work "lzma.7z"
if (-not (Test-Path (Join-Path $work "bin\7zSD.sfx"))) {
    $urls = @(
        "https://www.7-zip.org/a/lzma2603.7z",
        "https://sourceforge.net/projects/sevenzip/files/LZMA%20SDK/lzma2603.7z/download"
    )
    foreach ($u in $urls) {
        try { Invoke-WebRequest -Uri $u -OutFile $sdk -UserAgent "curl"; break } catch { Write-Warning "Download fallito: $u" }
    }
    & $sevenZip x $sdk "-o$work" "bin\7zSD.sfx" -y | Out-Null
}
$sfx = Join-Path $work "7zSD-custom.sfx"
Copy-Item (Join-Path $work "bin\7zSD.sfx") $sfx -Force

# L'icona dell'exe finale è quella del modulo SFX: va cambiata prima di concatenare.
$rcedit = Join-Path $work "rcedit-x64.exe"
if (-not (Test-Path $rcedit)) {
    Invoke-WebRequest -Uri "https://github.com/electron/rcedit/releases/download/v2.0.0/rcedit-x64.exe" -OutFile $rcedit
}
# Il manifest (supportedOS + requestedExecutionLevel) disattiva il rilevamento
# installer di Windows e la finestra "Risoluzione problemi compatibilità" alla chiusura.
$manifest = Join-Path $PSScriptRoot "sfx.manifest"
& $rcedit $sfx --set-icon $Icon `
    --application-manifest $manifest `
    --set-version-string "FileDescription" $Title `
    --set-version-string "ProductName" $Title `
    --set-version-string "CompanyName" "MACCARINI MARICO ANGELO E C. SAS" `
    --set-version-string "LegalCopyright" "MarMac - www.marmac.it" `
    --set-version-string "OriginalFilename" $Output `
    --set-version-string "InternalName" $Title `
    --set-version-string "Comments" "" `
    --set-file-version "1.0.0.0" --set-product-version "1.0.0.0"
if ($LASTEXITCODE -ne 0) { throw "rcedit fallito" }

$exe = Join-Path $BuildDir "rustdesk.exe"
if (-not (Test-Path $exe)) { throw "Manca $exe" }

$archive = Join-Path $work "build.7z"
Remove-Item $archive -ErrorAction SilentlyContinue
# Da dentro la cartella: i file devono stare alla radice dell'archivio,
# altrimenti RunProgram="rustdesk.exe" non li trova.
Push-Location $BuildDir
try {
    & $sevenZip a -t7z $archive * -mx=5 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "7z fallito" }
} finally { Pop-Location }
$names = & $sevenZip l -slt $archive | Select-String '^Path = rustdesk\.exe$'
if (-not $names) { throw "rustdesk.exe non è alla radice dell'archivio" }

# Config in UTF-8 senza BOM: con il BOM 7zSD non riconosce l'intestazione.
$config = ";!@Install@!UTF-8!`r`nTitle=`"$Title`"`r`nRunProgram=`"rustdesk.exe`"`r`n;!@InstallEnd@!`r`n"
$cfgBytes = (New-Object System.Text.UTF8Encoding($false)).GetBytes($config)

$out = [System.IO.File]::Create((Join-Path (Get-Location) $Output))
try {
    foreach ($bytes in @([System.IO.File]::ReadAllBytes($sfx), $cfgBytes, [System.IO.File]::ReadAllBytes($archive))) {
        $out.Write($bytes, 0, $bytes.Length)
    }
} finally { $out.Close() }
Write-Host "OK: $Output ($((Get-Item $Output).Length) byte)"
