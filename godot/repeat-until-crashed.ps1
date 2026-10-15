$godot = 'C:\Tools\godot\Godot_v4.7.2-stable_mono_win64_console.exe'
$i = 0
do {
    $i++
    & $godot --import --headless
} while ($LASTEXITCODE -eq 0)
Write-Host "Run $i exited with $LASTEXITCODE"
