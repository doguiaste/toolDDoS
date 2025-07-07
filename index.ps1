# start_script.ps1
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$pythonScript = Join-Path $scriptPath "start.py"
python "$pythonScript"
