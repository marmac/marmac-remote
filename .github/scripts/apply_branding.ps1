# Copia le icone della variante (slave/master) nelle posizioni usate dalla build.
# Va eseguito prima di "Build Rust lib": la tray icon è incorporata con include_bytes!.
param([Parameter(Mandatory)] [ValidateSet("slave", "master")] [string] $Variant)
$ErrorActionPreference = "Stop"
$src = "res\marmac\$Variant"
$map = @{
    "icon.ico"      = @("res\icon.ico", "flutter\windows\runner\resources\app_icon.ico")
    "tray-icon.ico" = @("res\tray-icon.ico")
    "icon.png"      = @("res\icon.png")
    "icon.svg"      = @("flutter\assets\icon.svg")
}
foreach ($file in $map.Keys) {
    foreach ($dst in $map[$file]) {
        Copy-Item (Join-Path $src $file) $dst -Force
        Write-Host "$Variant/$file -> $dst"
    }
}
