$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

if (-not (Test-Path ".venv")) {
    uv venv --python 3.12
}

uv pip install -r requirements.txt

$diagramDir = Join-Path $projectRoot "data\PaperBananaBench\diagram"
$plotDir = Join-Path $projectRoot "data\PaperBananaBench\plot"

New-Item -ItemType Directory -Force -Path $diagramDir | Out-Null
New-Item -ItemType Directory -Force -Path $plotDir | Out-Null

foreach ($file in @(
    (Join-Path $diagramDir "ref.json"),
    (Join-Path $diagramDir "test.json"),
    (Join-Path $plotDir "ref.json"),
    (Join-Path $plotDir "test.json")
)) {
    if (-not (Test-Path $file)) {
        [System.IO.File]::WriteAllText($file, "[]`n", (New-Object System.Text.UTF8Encoding($false)))
    }
}

& ".\.venv\Scripts\streamlit.exe" run demo.py --server.port 8501 --server.address 0.0.0.0