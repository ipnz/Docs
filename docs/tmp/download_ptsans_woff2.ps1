[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$urls = @(
  'https://fonts.gstatic.com/s/ptsansnarrow/v19/BngRUXNadjH0qYEzV7ab-oWlsbCLwR26eg.woff2',
  'https://fonts.gstatic.com/s/ptsansnarrow/v19/BngRUXNadjH0qYEzV7ab-oWlsbCCwR26eg.woff2',
  'https://fonts.gstatic.com/s/ptsansnarrow/v19/BngRUXNadjH0qYEzV7ab-oWlsbCIwR26eg.woff2',
  'https://fonts.gstatic.com/s/ptsansnarrow/v19/BngRUXNadjH0qYEzV7ab-oWlsbCGwR0.woff2',
  'https://fonts.gstatic.com/s/ptsansnarrow/v19/BngSUXNadjH0qYEzV7ab-oWlsbg95AiIW_3QRQ.woff2',
  'https://fonts.gstatic.com/s/ptsansnarrow/v19/BngSUXNadjH0qYEzV7ab-oWlsbg95AiBW_3QRQ.woff2',
  'https://fonts.gstatic.com/s/ptsansnarrow/v19/BngSUXNadjH0qYEzV7ab-oWlsbg95AiLW_3QRQ.woff2',
  'https://fonts.gstatic.com/s/ptsansnarrow/v19/BngSUXNadjH0qYEzV7ab-oWlsbg95AiFW_0.woff2'
)
$dir = 'C:\Data\web\ipnz\Docs\docs\assets\fonts'
foreach ($u in $urls) {
  $f = Split-Path $u -Leaf
  $out = Join-Path $dir $f
  if (-not (Test-Path $out)) {
    try {
      Invoke-WebRequest -Uri $u -OutFile $out -UseBasicParsing -ErrorAction Stop
      Write-Host "Saved $f"
    } catch {
      Write-Host "Failed $u"
    }
  } else {
    Write-Host "Already exists $f"
  }
}
Get-ChildItem $dir -Filter '*ptsans*' | Select-Object Name,Length | Sort-Object Name | Format-Table -AutoSize
