<#
<Title>TextFileSearcher.ps1</Title>
<Author>Sohaib Shaheed (SOSHAH)</Author>
<Version>1.0</Version>
<PublishDate>28-09-2020</PublishDate>
#>
param([string]$directory)


write-host "Searching Text Files for Specified Keywords" -ForegroundColor Green

write-host "<Title>TextFileSearcher.ps1</Title>" -ForegroundColor Yellow
write-host "<Author>Sohaib Shaheed (SOSHAH)</Author>" -ForegroundColor Yellow
write-host "<Version>1.0</Version>" -ForegroundColor Yellow
write-host "<PublishDate>28-09-2020</PublishDate>" -ForegroundColor Yellow

[System.Collections.ArrayList]$keywordlist = @()


$keyword= $null

    while ($keyword -ne "q"){
        $keyword = Read-Host -Prompt "Please enter a keyword or string or Regex to search. Enter only q to quit entering keywords"
        if ($keyword -ne "q"){
            $keywordlist.add($keyword)
        }
    }
"The search will be performed with these keywords: $keywordlist"

$timestamp = Get-Date -Format yyyymmddhhmmss

$outfilename = "{0}\{1}.KeywordSearchResults" -f $directory,$timestamp

write-host "Output saved in $outfilename" -ForegroundColor Green

$keywordlist -join " | " | Out-File $outfilename

$keywordlist `
| foreach{ls -Path $directory -recurse  `
| where name -match ".txt|.log|.html|.htm|.csv|.xml|.json|.exe.config|.ini|.cfg|.conf" `
| Select-String -Pattern $_ `
| Select Path, Linenumber, Line, "---------------" -Verbose `
| FL * `
| Out-File $outfilename -Append -Width 1000 `
}

try{
    Invoke-Expression "$ENV:LOCALAPPDATA\Apps\2.0\0XNGJ0RK.L7M\KJT7N0H9.8QH\etwb..tion_0000000000000000_0001.0002_4610bfe88690a93d\TextAnalysisTool.NET.exe $outfilename"
}catch{
    
    try{
        notepad++ $outfilename
    }catch{
        notepad $outfilename
    }
}


try{

# Check Az PowerShell Modules

    $AzModuleVersion = Get-InstalledModule -Name az
    if (($AzModuleVersion.version.major -ge 3) -and ($AzModuleVersion.version.minor -ge 2)){
        #Write-Host "Azure PowerShell Version is greater than 3.2.0"
    }else{
        if($AzModuleVersion.Version.GetType().Name -eq "Version")
            {
                Write-Host "Azure Powershell Version needs updating. Please run 'Install-Module -Name Az -AllowClobber' as an admin ";
                Write-Error "Azure Powershell Version older than what the script has been tested with" -ErrorAction Stop
            }else{
                "Get-InstalledModule -Name Az returned a String, comparing"
                if(($AzModuleVersion.Version.Substring(0,$AzModuleVersion.Version.IndexOf(".")) -ge 3) -and ($AzModuleVersion.Version.Substring($AzModuleVersion.Version.IndexOf(".")+1,$AzModuleVersion.Version.lastindexof(".")-2) -ge 2)){
                    #Write-Host "Azure PowerShell Version is greater than 3.2.0"
                }else{
                    Write-Host "Azure Powershell Version needs updating. Please run 'Install-Module -Name Az -AllowClobber' as an admin ";
                    Write-Error "Azure Powershell Version older than what the script has been tested with" -ErrorAction Stop
                }

            }
    }

$usage = Get-Date -UFormat "%Y%m%d%H%M%S%Z"
$usage|Out-File "$directory\$usage-$env:username.txt"
$connectionstring = "FileEndpoint=https://supporttoolusage.file.core.windows.net/;SharedAccessSignature=sv=2019-12-12&ss=f&srt=o&sp=rw&se=2020-12-31T23:59:59Z&st=2020-09-28T13:12:27Z&spr=https&sig=delYLuwJblMImm2jGePVtNMr7P3OPioydCFhjC1NkP8%3D"
$ctx = New-AzureStorageContext -ConnectionString "$connectionstring"
$OriginalPref = $ProgressPreference # Default is 'Continue'
$ProgressPreference = "SilentlyContinue"
Set-AzureStorageFileContent -ShareName "tmusage" -Context $ctx -Source "$directory\$usage-$env:username.txt" -ErrorAction Stop
$ProgressPreference = $OriginalPref
Remove-Item -Path "$directory\$usage-$env:username.txt" -Force
"Telemetry Updated"

}catch{
"Telemetry Failed"
}

write-host "AzureSupportTools will self-update now and this PowerShell Window will self-close in 10 seconds..." -ForegroundColor Green

(iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/install.ps1 -UseBasicParsing).content | iex | out-null

Start-Sleep -Seconds 10
