<#
<Title>install.ps1</Title>
<Author>Sohaib Shaheed (SOSHAH)</Author>
<Version>1.3</Version>
<PublishDate>04-10-2020</PublishDate>
#>

# Set Up The Folder

$installationpath = "$ENV:LOCALAPPDATA\AzureSupportUtilities"

# Check if Installation Folder exists.

if(Test-Path -Path $installationpath){
    write-host "Installation Directory Exists" -ForegroundColor Green
}else{
    New-Item -Path "$ENV:LOCALAPPDATA\AzureSupportUtilities" -ItemType Directory -Force
}

#Get the install file from GITHUB

#Download PS1 Files

 (iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/install.ps1 -UseBasicParsing).content | out-file -FilePath "$installationpath\install.ps1" -force
 (iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/TextFileSearcher.ps1 -UseBasicParsing).content | out-file -FilePath "$installationpath\TextFileSearcher.ps1" -force
 (iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/MergeExportEventLogs.ps1 -UseBasicParsing).content | out-file -FilePath "$installationpath\MergeExportEventLogs.ps1" -force
 (iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/UPD.tat -UseBasicParsing).content | out-file -FilePath "$installationpath\UPD.tat" -force
 (iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/RDS.tat -UseBasicParsing).content | out-file -FilePath "$installationpath\RDS.tat" -force
#Place in Default Location

#Update Registry Entries
<# #>

if (Test-Path -Path "HKCU:\SOFTWARE\Classes\Directory\shell"){
    "Registry Key Exists"
}else{
    New-Item -Path "HKCU:\SOFTWARE\Classes\Directory" -Name "shell"  –Force
}

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell" -Name "Azure Utilities"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell" -Name "MUIVerb" -Value  "Azure Utilities"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities" -Name "subcommands" -Value  ""  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities" -Name "Icon" -Value  "%SystemRoot%\System32\SHELL32.dll,209"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities" -Name "shell"  –Force
#Text-based Search `[Keyword(s)`]

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Text-based Search `[Keyword(s)`] | Regex"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Keyword(s)``] | Regex" -Name "Icon" -Value  "C:\Windows\System32\notepad.exe"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Keyword(s)``] | Regex" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Keyword(s)``] | Regex\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$installationpath\TextFileSearcher.ps1'""  '%1' 'KEY'"  –Force

#Text-based Search `[Lines with IP Addresses`]

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Text-based Search `[Lines with IP Addresses`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Lines with IP Addresses``]" -Name "Icon" -Value  "C:\Windows\System32\notepad.exe"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Lines with IP Addresses``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Lines with IP Addresses``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$installationpath\TextFileSearcher.ps1'""  '%1' 'IPS'"  –Force

#Windows Events: Merge>Sort>Export to Text `[ALL`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[ALL`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ALL``]" -Name "Icon" -Value  """C:\Windows\System32\miguiresource.dll"",0"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ALL``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ALL``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$installationpath\MergeExportEventLogs.ps1'""  'ALL'  '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[EVT`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[EventID(s)`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[EventID(s)``]" -Name "Icon" -Value  """C:\Windows\System32\miguiresource.dll"",0"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[EventID(s)``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[EventID(s)``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$installationpath\MergeExportEventLogs.ps1'""  'EVT'  '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[ERR`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[ERRORS`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ERRORS``]" -Name "Icon" -Value  """C:\Windows\System32\miguiresource.dll"",0"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ERRORS``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ERRORS``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$installationpath\MergeExportEventLogs.ps1'""  'ERR'  '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[KEY`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[Keyword(s)`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Keyword(s)``]" -Name "Icon" -Value  """C:\Windows\System32\miguiresource.dll"",0"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Keyword(s)``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Keyword(s)``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$installationpath\MergeExportEventLogs.ps1'"" 'KEY' '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[REB`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[Reboots`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Reboots``]" -Name "Icon" -Value  """C:\Windows\System32\miguiresource.dll"",0"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Reboots``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Reboots``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$installationpath\MergeExportEventLogs.ps1'"" 'REB' '%1'"  –Force

# Windows Events: Merge>Sort>Export to Text `[Events with IP Addresses`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[Events with IP Addresses`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Events with IP Addresses``]" -Name "Icon" -Value  """C:\Windows\System32\miguiresource.dll"",0"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Events with IP Addresses``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Events with IP Addresses``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$installationpath\MergeExportEventLogs.ps1'"" 'IPS' '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[UPD`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[Update History`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Update History``]" -Name "Icon" -Value  """C:\Windows\System32\miguiresource.dll"",0"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Update History``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Update History``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$installationpath\MergeExportEventLogs.ps1'""  'UPD'  '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[RDS`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[RDS and RDP History`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[RDS and RDP History``]" -Name "Icon" -Value  """C:\Windows\System32\miguiresource.dll"",0"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[RDS and RDP History``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[RDS and RDP History``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$installationpath\MergeExportEventLogs.ps1'""  'RDS'  '%1'"  –Force


# TextAnalysisTool.NET Installation

try{
    $TATOutputDir = "$env:LOCALAPPDATA\TextAnalysisTool.NET"
    $TATOutput = "$TATOutputDir\TextAnalysisTool.NET.zip"
        
    if(Test-Path -Path "$TATOutputDir\TextAnalysisTool.NET.exe"){
        Write-Host "Text Analysis Tool.NET already present" -ForegroundColor Green
    }
    else
    {
        md -Path $TATOutputDir -Force
        $url = "https://github.com/TextAnalysisTool/Releases/raw/master/TextAnalysisTool.NET.zip"
        $TATOutput = "$TATOutputDir\TextAnalysisTool.NET.zip"
        Start-BitsTransfer -Source $url -Destination $TATOutput -ErrorAction SilentlyContinue
        Expand-Archive -Path $TATOutput -DestinationPath $TATOutputDir -Force
        Write-Host "TextAnalysisTool.NET Download Complete" -ForegroundColor Green
    }
}catch{
    Write-Host "TextAnalysisTool.NET Download Failed" -ForegroundColor Red
}

# TATPlugin Installation

try{
    $TATOutputDir = "$env:LOCALAPPDATA\TextAnalysisTool.NET"
    $TATPluginOutput = "$TATOutputDir\TATPLUGIN_Insight.dll"
        
    if(Test-Path -Path "$TATPluginOutput"){
        Write-Host "TATPlugin already present" -ForegroundColor Green
    }
    else
    {
        md -Path $TATOutputDir -Force
        Start-BitsTransfer -Source "\\emeacat\InsightClient\Application Files\ETWBench_1_2_5_2\TATPLUGIN_Insight.dll.deploy" -Destination $TATPluginOutput -ErrorAction SilentlyContinue
        Write-Host "TATPlugin Download Complete" -ForegroundColor Green
    }
}catch{
    Write-Host "TATPlugin Download Failed" -ForegroundColor Red
}

# TATAppInsightsPlugin Installation

try{
    $TATOutputDir = "$env:LOCALAPPDATA\TextAnalysisTool.NET"
    $TATAppInsightsOutput = "$TATOutputDir\Microsoft.ApplicationInsights.dll"
        
    if(Test-Path -Path "$TATAppInsightsOutput "){
        Write-Host "TATAppInsightsDLL already present" -ForegroundColor Green
    }
    else
    {
        md -Path $TATOutputDir -Force
        Start-BitsTransfer -Source "\\emeacat\InsightClient\Application Files\ETWBench_1_2_5_2\Microsoft.ApplicationInsights.dll.deploy" -Destination $TATAppInsightsOutput  -ErrorAction SilentlyContinue
        Write-Host "TATAppInsightsDLL Download Complete" -ForegroundColor Green
    }
}catch{
    Write-Host "TATAppInsightsDLL Download Failed" -ForegroundColor Red
}


try{
# Check Az PowerShell Modules

    $AzModuleVersion = Get-InstalledModule -Name az -ErrorAction SilentlyContinue
    if (($AzModuleVersion.version.major -ge 4) -and ($AzModuleVersion.version.minor -ge 7)){
         Write-Host "Azure PowerShell Version is $($AzmoduleVersion.Version)" -ForegroundColor Green
    }else{
        if($AzModuleVersion.Version.GetType().Name -eq "Version")
            {
                Write-Error "Azure Powershell Version needs updating. Please run 'Install-Module -Name Az -AllowClobber' as an admin " -ErrorAction stop;
                
            }else{
                #"Get-InstalledModule -Name Az returned a String, comparing"
                if(($AzModuleVersion.Version.Substring(0,$AzModuleVersion.Version.IndexOf(".")) -ge 4) -and ($AzModuleVersion.Version.Substring($AzModuleVersion.Version.IndexOf(".")+1,$AzModuleVersion.Version.lastindexof(".")-2) -ge 7)){
                    Write-Host "Azure PowerShell Version is $($AzmoduleVersion.Version)" -ForegroundColor Green
                }else{
                    Write-Error "Azure Powershell Version needs updating. Please run 'Install-Module -Name Az -AllowClobber' as an admin " -ErrorAction Stop;
                }

            }
    }
}catch{
       Write-Host "Azure Powershell Version needs Installing/Updating. Please run 'Install-Module -Name Az -AllowClobber' as an admin " -ForegroundColor Yellow;
       
       Write-host "Would you like to update your Azure PowerShell version? (Default is No)" -ForegroundColor Yellow 
       $Readhost = Read-Host " ( y / n ) " 
       Switch ($ReadHost) 
         { 
           Y {Write-host "Yes, Update Azure PowerShell Modules"; $UpdateAnswer=$true} 
           N {Write-Host "Skipping update"; $UpdateAnswer=$false} 
           Default {Write-Host "Skipping update"; $UpdateAnswer=$false} 
         } 
       if($UpdateAnswer){start-process powershell -Verb RunAs -ArgumentList "Write-host 'Installing Azure PowerShell module' -ForegroundColor Green;Install-Module -Name Az -AllowClobber"}
}

try{
    $usage = Get-Date -UFormat "%Y%m%d%H%M%S%Z"
    $telemetryfilename = "$installationpath\$usage-$env:username-Install.txt"
    $usage|Out-File $telemetryfilename
    $connectionstring = "FileEndpoint=https://supporttoolusage.file.core.windows.net/;SharedAccessSignature=sv=2019-12-12&ss=f&srt=o&sp=rw&se=2021-12-31T23:59:59Z&st=2020-12-28T10:14:22Z&spr=https&sig=5kJH1Ok2CebU0cMP%2F%2BnNy7G5m6MXD37zl8CfQoLodug%3D"
    $ctx = New-AzStorageContext -ConnectionString "$connectionstring"
    $OriginalPref = $ProgressPreference # Default is 'Continue'
    $ProgressPreference = "SilentlyContinue"
    Set-AzStorageFileContent -ShareName "tmusage" -Context $ctx -Source $telemetryfilename -ErrorAction Stop -ClientTimeOutPerRequest 10 -asjob|Out-Null
    start-sleep -Seconds 5
    $ProgressPreference = $OriginalPref
    Remove-Item -Path $telemetryfilename -Force
    "Telemetry Updated"
}catch{
    "Telemetry Failed"
}

Write-host "Installation/Update Complete - Contact soshah@microsoft.com for any questions or feedback" -ForegroundColor Green



