$SQLServer = "homologacao.sql.fitcard.com.br"
$db3 = "Fitcard_Sisatec"
$selectdata = "Use s_3818;Select obs_os from os where cod_os = 96"
$username = "ftcr.sql.hml"
$password = "MkTY1NP4n"
$localScriptRoot = "C:\Code\TesteDeployAzure\"
$localScriptHomologacao = "C:\Code\TesteDeployAzure\Homologacao"
$scripts = Get-ChildItem $localScriptRoot | Where-Object {$_.Extension -eq ".sql"}
 
foreach ($s in $scripts)
    {
        #Execute each script and then move it
        Write-Host "Running Script : " $s.Name -BackgroundColor DarkGreen -ForegroundColor White
        $script = $s.FullName
        Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -InputFile $script -Username $username -Password $password -Verbose     
        Move-Item -Path $s.FullName -Destination $localScriptHomologacao
    }

#Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -InputFile $inputfile -Username $username -Password $password -Verbose
#Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -InputFile $inputfile2 -Username $username -Password $password -Verbose
Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -Query $selectdata -Username $username -Password $password -Verbose

Git commit -m "Automated commit"
