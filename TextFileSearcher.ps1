<#
<Title>TextFileSearcher.ps1</Title>
<Author>Sohaib Shaheed (SOSHAH)</Author>
<Version>1.3</Version>
<PublishDate>04-10-2020</PublishDate>
#>
param([string]$directory, [string]$searchstring)

write-host "Searching Text Files for Specified Keywords" -ForegroundColor Green

write-host "<Title>TextFileSearcher.ps1</Title>" -ForegroundColor Yellow
write-host "<Author>Sohaib Shaheed (SOSHAH)</Author>" -ForegroundColor Yellow
write-host "<Version>1.3</Version>" -ForegroundColor Yellow
write-host "<PublishDate>04-10-2020</PublishDate>" -ForegroundColor Yellow


$timestamp = Get-Date -Format yyyyMMddHHmmss

$outfilename = "{0}\{1}.KeywordSearchResults" -f $directory,$timestamp

write-host "Output saved in $outfilename" -ForegroundColor Green


if ($searchstring -eq "KEY")
{
    $keywords=$null
    $keyword= $null
    while ($keyword -ne "q"){
        $keyword = Read-Host -Prompt "Please enter a keyword or string to search. Enter only q to quit entering keywords"
        if($keywords -eq $null){
            $keywords=$keywords+$keyword
        }elseif ($keyword -ne "q"){
            $keywords=$keywords+"|"+ $keyword
        }
    }
    "The search will be performed with these keywords: $keywords"

$keywords | Out-File $outfilename

$keywords `
| foreach{ls -Path $directory -recurse  `
| where name -match ".txt|.log|.html|.htm|.csv|.xml|.json|.config|.ini|.cfg|.conf|.settings|.bgi|.dsc|.tag|tsv" `
| Select-String -Pattern $_ `
| Select Path, Linenumber, Line, "---------------" -Verbose `
| FL * `
| Out-File $outfilename -Append -Width 1000 `
}
} elseif($searchstring -eq "IPS"){

"Searching for lines containing IP Addresses" | Out-File $outfilename

ls -Path $directory -recurse  `
| where name -match ".txt|.log|.html|.htm|.csv|.xml|.json|.config|.ini|.cfg|.conf|.settings|.bgi|.dsc|.tag|tsv" `
| Select-String -Pattern "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b" `
| Select Path, Linenumber, Line, "---------------" -Verbose `
| FL * `
| Out-File $outfilename -Append -Width 1000 `

}

try{
    Invoke-Expression "$ENV:LOCALAPPDATA\TextAnalysisTool.NET\TextAnalysisTool.NET.exe '$outfilename'"
}catch{
    
    try{
        notepad++ "$outfilename"
    }catch{
        notepad "$outfilename"
    }
}


#Telemetry
<#
try{
# Check Az PowerShell Modules

    $AzModuleVersion = Get-InstalledModule -Name az -ErrorAction SilentlyContinue
    if (($AzModuleVersion.version.major -ge 3) -and ($AzModuleVersion.version.minor -ge 2)){
         Write-Host "Azure PowerShell Version is $($AzmoduleVersion.Version)" -ForegroundColor Green
    }else{
        if($AzModuleVersion.Version.GetType().Name -eq "Version")
            {
                Write-Host "Azure Powershell Version needs updating. Please run 'Install-Module -Name Az -AllowClobber' as an admin ";
                
            }else{
                #"Get-InstalledModule -Name Az returned a String, comparing"
                if(($AzModuleVersion.Version.Substring(0,$AzModuleVersion.Version.IndexOf(".")) -ge 3) -and ($AzModuleVersion.Version.Substring($AzModuleVersion.Version.IndexOf(".")+1,$AzModuleVersion.Version.lastindexof(".")-2) -ge 2)){
                    Write-Host "Azure PowerShell Version is $($AzmoduleVersion.Version)" -ForegroundColor Green
                }else{
                    Write-Host "Azure Powershell Version needs updating. Please run 'Install-Module -Name Az -AllowClobber' as an admin ";
                }

            }
    }
}catch{
       Write-Host "Azure Powershell Version needs Installing/Updating. Please run 'Install-Module -Name Az -AllowClobber' as an admin " -ForegroundColor Yellow;
}#>

try{
    $usage = Get-Date -UFormat "%Y%m%d%H%M%S%Z"
    $telemetryfilename = "$ENV:LOCALAPPDATA\AzureSupportUtilities\$usage-$env:username-TEXT-$searchstring.txt"
    "$usage $directory"|Out-File $telemetryfilename
    $connectionstring = "FileEndpoint=https://supporttoolusage.file.core.windows.net/;SharedAccessSignature=sv=2019-12-12&ss=f&srt=o&sp=rw&se=2020-12-31T23:59:59Z&st=2020-09-28T13:12:27Z&spr=https&sig=delYLuwJblMImm2jGePVtNMr7P3OPioydCFhjC1NkP8%3D"
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

write-host "AzureSupportTools will self-update now" -ForegroundColor Green

try{
(iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/install.ps1 -UseBasicParsing -TimeoutSec 8 -ErrorAction SilentlyContinue).content | iex -ErrorAction SilentlyContinue | out-null
}
catch{
Write-host "Update Failed" -ForegroundColor Red
}

write-host "This window will self-close in 10 seconds" -ForegroundColor Green
Start-Sleep -Seconds 10


