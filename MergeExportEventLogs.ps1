<#
<Title>MergeExportEventLogs.ps1</Title>
<Author>Sohaib Shaheed (SOSHAH)</Author>
<Version>1.1</Version>
<PublishDate>29-09-2020</PublishDate>
#>
param([string]$filtertype,[string]$directory)


# Show Title
write-host "Merging and Exporting $filtertype Event Logs" -ForegroundColor Green

write-host "<Title>MergeExportEventLogs.ps1</Title>" -ForegroundColor Yellow
write-host "<Author>Sohaib Shaheed (SOSHAH)</Author>" -ForegroundColor Yellow
write-host "<Version>1.1</Version>" -ForegroundColor Yellow
write-host "<PublishDate>29-09-2020</PublishDate>" -ForegroundColor Yellow

# Get List of all EVTX Files
$evtxfiles = Get-ChildItem -Path $directory -Filter *.evtx -Recurse

# Tell user how many found
"Found {0} files" -f $evtxfiles.count

# Display a list of the found files
$evtxfiles|FT Name -AutoSize


$earlydate = Read-Host -Prompt "How many days in the past do you want to search from? (enter an number, e.g. '1' for 24hrs ago, '0.5' for 12 hours ago)"

$earlydate = (Get-Date).AddDays(([float]$earlydate)*-1)

$latedate = Read-Host -Prompt "How many days in the past do you want to search to? (enter an number, e.g. '1' for 24hrs ago, '0.5' for 12 hours ago)"


$latedate = (Get-Date).AddDays(([float]$latedate)*-1)

if ($latedate -lt $earlydate){
    Write-host "'To' date ($latedate) supplied is earlier than 'From' date ($earlydate), swapping these around" -ForegroundColor Red
    
    $latedateswap = $latedate
    $latedate = $earlydate
    $earlydate = $latedateswap

}

write-host "Searching for Events in all logs from $earlydate to $latedate" -ForegroundColor Green

$events = $null

if ($filtertype -eq "KEY"){
    
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

    #for ($i=0;$i -lt $keywords.Count; $i++){        $searchterm = "{0}" -f  $keywords[$i]    }

    $evtxfiles | foreach {
        $oldeventscount = $events.count
        "Reading {0}" -f $_.Name
        "Time to Parse : {0} Seconds" -f (measure-command{$events+=(Get-WinEvent -FilterHashtable @{ Path=$_.fullname; StartTime=$earlydate;EndTime=$latedate;} -MaxEvents 5000 -ErrorAction SilentlyContinue | where {$_.TimeCreated -ge $earlydate -and $_.TimeCreated -le $latedate -and ($_.message -match $keywords -or $_.properties.value -match $keywords)})}).TotalSeconds
        "Events Added : {0}" -f (($events.count) - $oldeventscount);
    }

}elseif ($filtertype -eq "ALL"){

    $evtxfiles | foreach {
        $oldeventscount = $events.count
        "Reading {0}" -f $_.Name
        #"Time to Parse : {0} Seconds" -f (measure-command{$events+=(Get-WinEvent -Path $_.FullName -MaxEvents 6000 -ErrorAction SilentlyContinue | where {$_.TimeCreated -ge $earlydate -and $_.TimeCreated -le $latedate});}).TotalSeconds
        "Time to Parse : {0} Seconds" -f (measure-command{$events+=(Get-WinEvent -FilterHashtable @{ Path=$_.fullname; StartTime=$earlydate;EndTime=$latedate;} -MaxEvents 5000 -ErrorAction SilentlyContinue);}).TotalSeconds
        "Events Added : {0}" -f (($events.count) - $oldeventscount);
    }

} elseif  ($filtertype -eq "ERR") {

    $evtxfiles | foreach {
        $oldeventscount = $events.count
        "Reading {0}" -f $_.Name 
        "Time to Parse : {0} Seconds" -f (measure-command{$events+=(Get-WinEvent -FilterHashtable @{ Path=$_.fullname; StartTime=$earlydate;EndTime=$latedate;} -MaxEvents 5000 -ErrorAction SilentlyContinue | where {($_.message -match $filtertype -or $_.inmessage -match $filtertype)})}).TotalSeconds
        "Events Added : {0}" -f (($events.count) - $oldeventscount);
    }

} elseif ($filtertype -eq "EVT"){
    
    $eventids=$null
    $eventid= $null
    while ($eventid -ne "q"){
        $eventid = Read-Host -Prompt "Please enter an Event ID to search. Enter only q to quit entering Event IDs"
        if($eventids -eq $null){
            $eventids=$eventids+$eventid
        }elseif ($eventid -ne "q"){
            $eventids=$eventids+"|"+ $eventid
        }
    }
    "The search will be performed with these Event IDs: $eventids"

    #for ($i=0;$i -lt $eventids.Count; $i++){        $searchterm = "{0}" -f  $eventids[$i]    }

    $evtxfiles | foreach {
        #for ($i=0;$i -lt $eventids.Count; $i++){
        $oldeventscount = $events.count
        "Reading {0}" -f $_.Name
        "Time to Parse : {0} Seconds" -f (measure-command{$events+=(Get-WinEvent -FilterHashtable @{ Path=$_.fullname; StartTime=$earlydate;EndTime=$latedate;ID=$eventids.Split("|")} -MaxEvents 5000 -ErrorAction SilentlyContinue)}).TotalSeconds
        "Events Added : {0}" -f (($events.count) - $oldeventscount);
        #}
    }

} elseif ($filtertype -eq "REB"){
    
    $evtxfiles | foreach {
    
        $oldeventscount = $events.count
        "Reading {0}" -f $_.Name
        "Time to Parse : {0} Seconds" -f (measure-command{$events+=(Get-WinEvent -FilterHashtable @{ Path=$_.fullname; StartTime=$earlydate;EndTime=$latedate;ID=6009} -MaxEvents 5000 -ErrorAction SilentlyContinue)}).TotalSeconds
        "Events Added : {0}" -f (($events.count) - $oldeventscount);
    
    }

}


# $evtxfiles | foreach {$events+=(Get-WinEvent -Path $_.FullName -MaxEvents 3000 -ErrorAction SilentlyContinue -verbose | where {$_.TimeCreated -ge $earlydate -and $_.TimeCreated -le $latedate})}

$timestamp = Get-Date -Format yyyymmddhhmmss

"Total Events: {0}" -f $events.count 

if([int32]$events.count -eq 0){
   Write-Host "No Events were found between $earlydate and $latedate that met the criteria" -ForegroundColor Red
} 

$outfilename = "{0}\{1}-{2}-MergedEventLogs.MERGERESULT" -f $directory,$timestamp,$filtertype


write-host "Output saved in $outfilename" -ForegroundColor Green

#"Searching for $filtertype Events in all logs from $earlydate to $latedate" | out-file $outfilename

#$events | sort Timecreated | select Timecreated,message

$events | Select TimeCreated,Message,Id,Version,Qualifiers,Level,Task,Opcode,Keywords,RecordId,ProviderName,ProviderId,LogName,ProcessId,ThreadId,MachineName,UserId,ActivityId,RelatedActivityId,ContainerLog,MatchedQueryIds,Bookmark,LevelDisplayName,OpcodeDisplayName,TaskDisplayName,KeywordsDisplayNames,Properties,@{Label="InMessage"; Expression={$vari=$null;for($i=0;$i -lt ($_.properties.value).count;$i++){$vari=$vari+[string]($_.properties[$i].value)+" ";}$vari}},@{Label="------"; Expression={("---------");}}|sort timecreated|out-file $outfilename -Width 2000 -Append

try{
    Invoke-Expression "$ENV:LOCALAPPDATA\Apps\2.0\0XNGJ0RK.L7M\KJT7N0H9.8QH\etwb..tion_0000000000000000_0001.0002_4610bfe88690a93d\TextAnalysisTool.NET.exe $outfilename"
}catch{
    
    try{
        notepad++ $outfilename
    }catch{
        notepad $outfilename
    }
}


#Telemetry
try{

# Check Az PowerShell Modules

    $AzModuleVersion = Get-InstalledModule -Name az -ErrorAction SilentlyContinue
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
$ctx = New-AzStorageContext -ConnectionString "$connectionstring"
$OriginalPref = $ProgressPreference # Default is 'Continue'
$ProgressPreference = "SilentlyContinue"
Set-AzStorageFileContent -ShareName "tmusage" -Context $ctx -Source "$directory\$usage-$env:username.txt" -ErrorAction Stop -ClientTimeOutPerRequest 10 -asjob|Out-Null
start-sleep -Seconds 5
$ProgressPreference = $OriginalPref
Remove-Item -Path "$directory\$usage-$env:username.txt" -Force
"Telemetry Updated"

}catch{
"Telemetry Failed"
}

write-host "AzureSupportTools will self-update now and this PowerShell Window will self-close in 10 seconds..." -ForegroundColor Green

try{
(iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/install.ps1 -UseBasicParsing -TimeoutSec 8 -ErrorAction SilentlyContinue).content | iex -ErrorAction SilentlyContinue | out-null
}
catch{
Write-host "Update Failed" -ForegroundColor Red
}

Start-Sleep -Seconds 10

