$SQLServer = "homologacao.sql.fitcard.com.br"
$db3 = "Fitcard_Sisatec"
$selectdata = "Use s_3818;Select obs_os from os where cod_os = 96"
$username = "ftcr.sql.hml"
$password = "MkTY1NP4n"
$homologacao = "\Powershell"
#$localScriptHomologacao = $localScriptRoot + $homologacao

Install-PackageProvider -Name NuGet -Force
Install-Module -Name SqlServer -Force -Scope CurrentUser

#Get Scripts Location
Write-Host $PSScriptRoot
Set-Location $PSScriptRoot
Set-Location ..
$location = Get-Location
Write-Host "Localizacao " $location

#Set script destnation
$destination = Join-Path -Path $location -ChildPath "\Homologacao"
Write-Host "Destination " $destination

$scripts = Get-ChildItem $location | Where-Object {$_.Extension -eq ".sql"}
foreach ($s in $scripts)
    {
        #Execute each script and then move it
        Write-Host "Running Script : " $s.Name -BackgroundColor DarkGreen -ForegroundColor White
        $script = $s.FullName
        Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -InputFile $script -Username $username -Password $password -Verbose     
        Move-Item -Path $s.FullName -Destination $destination
    }

#Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -InputFile $inputfile -Username $username -Password $password -Verbose
#Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -InputFile $inputfile2 -Username $username -Password $password -Verbose
Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -Query $selectdata -Username $username -Password $password -Verbose

#Push script moves to git
Set-Location $location
Git pull
Git add .
Git commit -m "Automated commit"
Git push origin master
