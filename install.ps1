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
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory" -Name "shell" -Verbose –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell" -Name "Azure Utilities" -Verbose –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell" -Name "MUIVerb" -Value  "Azure Utilities" -Verbose –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities" -Name "subcommands" -Value  "" -Verbose –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities" -Name "shell" -Verbose –Force

#Text-based Search `[Keyword(s)`]

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Text-based Search `[Keyword(s)`] | Regex" -Verbose –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Keyword(s)``] | Regex" -Name "command" -Verbose –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Keyword(s)``] | Regex\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\TextFileSearcher.ps1'""  '%1'" -Verbose –Force

#Windows Events: Merge>Sort>Export to Text `[ALL`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[ALL`]" -Verbose –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ALL``]" -Name "command" -Verbose –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ALL``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\MergeExportEventLogs.ps1'""  'ALL'  '%1'" -Verbose –Force

#Windows Events: Merge>Sort>Export to Text `[ERR`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[ERRORS`]" -Verbose –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ERRORS``]" -Name "command" -Verbose –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[ERRORS``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\MergeExportEventLogs.ps1'""  'ERR'  '%1'" -Verbose –Force

#Windows Events: Merge>Sort>Export to Text `[KEY`]
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Windows Events: Merge>Sort>Export to Text `[Keyword(s)`]" -Verbose –Force

New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Keyword(s)``]" -Name "command" -Verbose –Force

New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Windows Events: Merge>Sort>Export to Text ``[Keyword(s)``]\command" -Name "(Default)" -Value  "powershell -noprofile -ExecutionPolicy Bypass & ""'$ENV:LOCALAPPDATA\AzureSupportUtilities\MergeExportEventLogs.ps1'"" 'KEY' '%1'" -Verbose –Force

<#
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell" -Name "Test [Keyword(s)]" -Verbose –Force
New-Item -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Text-based Search ``[Keyword(s)``] | Regex" -Name "command" -Verbose –Force
New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Directory\shell\Azure Utilities\shell\Test ``[Keyword(s)``]\command" -Name "(Default)" -Value  "powershell -noexit -noprofile -ExecutionPolicy Bypass & ""'C:\Users\soshah\OneDrive - Microsoft\Tools\AzureSupportUtilities\AzureSupportUtils\MergeExportEventLogs.ps1'"" 'ERR' '%1'" -Verbose –Force
#>
