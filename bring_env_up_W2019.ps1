If(!(test-path c:\temp))
{
    New-Item -ItemType Directory -Force -Path c:\temp
}

Copy-Item "run_configurator.bat" -Destination "C:\temp\run_configurator.bat"

./docker-app-windows render admpresales/lre.dockerapp:2020 | docker-compose -p lre -f - logs -f

# next sleep is for mssql container to finish health checks
Start-Sleep -s 30


# filesystem ops run only against non Hyper-V containers, thus good for WSrv2016, not good for Win10
# docker cp run_configurator.bat pcs:/ -- to use with WSrv2016

docker cp lre:C:\PC_Server\dat\PCS.config c:\temp
(Get-Content -Path c:\temp\PCS.config) | ForEach-Object {$_ -replace "http://\w{12}", "http://lreserver"} | Set-Content -Path c:\temp\PCS.config
docker cp c:\temp\PCS.config lre:C:\PC_Server\dat
docker exec lre powershell iisreset
# configuration wizzard from last step is stopping, deleting, recreating and starting 'LoadRunner Backend Service', hence need to restart it here
# docker exec lre powershell "Restart-Service 'LoadRunner Backend Service'"

docker exec -d lre powershell c:\temp\run_configurator.bat
Write-Host "Running Configuration Wizzard, wait another five minutes before connecting to LRE !!!"