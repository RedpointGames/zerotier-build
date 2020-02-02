param()

$ErrorActionPreference = "Stop"

function RemoveMSVCFlags($Path) {
    $Content = (Get-Content -Raw $Path)
    $Content = $Content.Replace("/EHsc", "")
    $Content = $Content.Replace("/W3 /MP", "")
    Set-Content -Path $Path -Value $Content
}

if (Test-Path $PSScriptRoot\build) {
    Remove-Item -Force $PSScriptRoot\build
}
mkdir $PSScriptRoot\build
Push-Location $PSScriptRoot\build
try {
    RemoveMSVCFlags $PSScriptRoot\libzt\CMakeLists.txt
    RemoveMSVCFlags $PSScriptRoot\libzt\zto\java\CMakeLists.txt
    $env:CXXFLAGS="-fpermissive"
    cmake -G "MinGW Makefiles" ..\libzt
    mingw32-make zt
} finally {
    Pop-Location
}