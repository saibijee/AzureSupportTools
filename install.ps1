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

 (iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/TextFileSearcher.ps1 -UseBasicParsing).content | out-file -FilePath "$ENV:LOCALAPPDATA\AzureSupportUtilities\TextFileSearcher.ps1"
 (iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/MergeExportEventLogs.ps1 -UseBasicParsing).content | out-file -FilePath "$ENV:LOCALAPPDATA\AzureSupportUtilities\MergeExportEventLogs.ps1"
#Place in Default Location

#Update Registry Entries
<# #>
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory" -Name "shell"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell" -Name "Azure Utilities"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell" -Name "MUIVerb" -Value  "Azure Utilities"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities" -Name "subcommands" -Value  ""  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities" -Name "shell"  –Force

#Text-based Search `[Keyword(s)`]

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Text-based Search `[Keyword(s)`] | Regex"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Keyword(s)``] | Regex" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Keyword(s)``] | Regex\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\TextFileSearcher.ps1'""  '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[ALL`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[ALL`]"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ALL``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ALL``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\MergeExportEventLogs.ps1'""  'ALL'  '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[ERR`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[ERRORS`]"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ERRORS``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ERRORS``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\MergeExportEventLogs.ps1'""  'ERR'  '%1'"  –Force

#Windows Events: Merge>Sort>Export to Text `[KEY`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[Keyword(s)`]"  –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Keyword(s)``]" -Name "command"  –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Keyword(s)``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\MergeExportEventLogs.ps1'"" 'KEY' '%1'"  –Force

Write-host "Installation Complete - Contact soshah@microsoft.com for any questions or feedback" -ForegroundColor Green
