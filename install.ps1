<#
<Title>MergeExportEventLogs.ps1</Title>
<Author>Sohaib Shaheed (SOSHAH)</Author>
<Version>1.0</Version>
<PublishDate>28-09-2020</PublishDate>
#>


#Get the install file from GITHUB


#Execute it

#Download PS1 Files
New-Item -Path "$ENV:LOCALAPPDATA\AzureSupportUtilities" -ItemType Directory -Force
 (iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/install.ps1 -UseBasicParsing).content | out-file -FilePath "$ENV:LOCALAPPDATA\AzureSupportUtilities\install.ps1"
 (iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/TextFileSearcher.ps1 -UseBasicParsing).content | out-file -FilePath "$ENV:LOCALAPPDATA\AzureSupportUtilities\TextFileSearcher.ps1"
 (iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/MergeExportEventLogs.ps1 -UseBasicParsing).content | out-file -FilePath "$ENV:LOCALAPPDATA\AzureSupportUtilities\MergeExportEventLogs.ps1"
#Place in Default Location

#Update Registry Entries
<# #>
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory" -Name "shell"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell" -Name "Azure Utilities"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell" -Name "MUIVerb" -Value  "Azure Utilities"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities" -Name "subcommands" -Value  ""  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities" -Name "Icon" -Value  "%SystemRoot%\System32\SHELL32.dll,209"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities" -Name "shell"  –Force

#Text-based Search `[Keyword(s)`]

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Text-based Search `[Keyword(s)`] | Regex"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Keyword(s)``] | Regex" -Name "Icon" -Value  "C:\Windows\System32\notepad.exe"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Keyword(s)``] | Regex" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Keyword(s)``] | Regex\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\TextFileSearcher.ps1'""  '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[ALL`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[ALL`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ALL``]" -Name "Icon" -Value  """C:\Windows\System32\miguiresource.dll"",0"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ALL``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ALL``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\MergeExportEventLogs.ps1'""  'ALL'  '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[ERR`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[ERRORS`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ERRORS``]" -Name "Icon" -Value  """C:\Windows\System32\miguiresource.dll"",0"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ERRORS``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ERRORS``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\MergeExportEventLogs.ps1'""  'ERR'  '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[KEY`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[Keyword(s)`]"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Keyword(s)``]" -Name "Icon" -Value  """C:\Windows\System32\miguiresource.dll"",0"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Keyword(s)``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Keyword(s)``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\MergeExportEventLogs.ps1'"" 'KEY' '%1'"  –Force

try{
# Check Az PowerShell Modules

    $AzModuleVersion = Get-InstalledModule -Name az -ErrorAction SilentlyContinue
    if (($AzModuleVersion.version.major -ge 3) -and ($AzModuleVersion.version.minor -ge 2)){
        #Write-Host "Azure PowerShell Version is greater than 3.2.0"
    }else{
        if($AzModuleVersion.Version.GetType().Name -eq "Version")
            {
                Write-Host "Azure Powershell Version needs updating. Please run 'Install-Module -Name Az -AllowClobber' as an admin ";
                
            }else{
                "Get-InstalledModule -Name Az returned a String, comparing"
                if(($AzModuleVersion.Version.Substring(0,$AzModuleVersion.Version.IndexOf(".")) -ge 3) -and ($AzModuleVersion.Version.Substring($AzModuleVersion.Version.IndexOf(".")+1,$AzModuleVersion.Version.lastindexof(".")-2) -ge 2)){
                    #Write-Host "Azure PowerShell Version is greater than 3.2.0"
                }else{
                    Write-Host "Azure Powershell Version needs updating. Please run 'Install-Module -Name Az -AllowClobber' as an admin ";
                }

            }
    }
}catch{
       Write-Host "Azure Powershell Version needs Installing/Updating. Please run 'Install-Module -Name Az -AllowClobber' as an admin " -ForegroundColor Yellow;
}

Write-host "Installation/Update Complete - Contact soshah@microsoft.com for any questions or feedback" -ForegroundColor Green
