mkdir -p logs
Get-Process | Select-Object Name, Id, CPU | Export-Csv logs/services.csv
Write-Host "Service Logs has been saved to logs/services.csv"
