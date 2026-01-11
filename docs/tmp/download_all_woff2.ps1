[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36'
$cssUrl = 'https://fonts.googleapis.com/css?family=PT+Sans+Narrow:400,700%7CPT+Serif:400,700,400italic&display=swap'
Write-Host "Fetching CSS from $cssUrl"
$css = (Invoke-WebRequest -Uri $cssUrl -Headers @{ 'User-Agent' = $ua } -UseBasicParsing).Content

# Extract WOFF2 URLs
$pattern = 'https://fonts.gstatic.com/[^)\x27\x22\s]+\.woff2'
$matches = [regex]::Matches($css, $pattern) | ForEach-Object { $_.Value } | Sort-Object -Unique
Write-Host "Found $($matches.Count) unique WOFF2 URLs"

$dir = Join-Path $PSScriptRoot '..\assets\fonts' | Resolve-Path -ErrorAction Stop
$dir = $dir.Path
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$saved = 0
foreach ($u in $matches) {
  $f = Split-Path $u -Leaf
  $out = Join-Path $dir $f
  if (-not (Test-Path $out)) {
    try {
      Write-Host "Downloading $f"
      Invoke-WebRequest -Uri $u -OutFile $out -UseBasicParsing -ErrorAction Stop
      Write-Host "Saved: $f"
      $saved++
    } catch {
      Write-Host "Failed to download: $u -- $($_.Exception.Message)"
    }
  } else {
    Write-Host "Already exists: $f"
  }
}
Write-Host "Done. New files saved: $saved"
Write-Host ("WOFF2 files now in {0}:" -f $dir)
Get-ChildItem $dir -Filter *.woff2 | Select-Object Name,Length | Sort-Object Name | Format-Table -AutoSize

# Exit code reflects if anything was saved
if ($saved -gt 0) { exit 0 } else { exit 0 }