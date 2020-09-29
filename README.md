# Azure Support Utilities

This is a collection of scripts that integrate with Windows Shell, and performs some basic tasks such as searching through a whole folder recursively.

### Need: 

I have been working on quite a few cases where I’ve had to review Windows Event logs and numerous text-based log files. Usually it takes a really long time to go through all the Event Logs etc and to identify the flow of what actually may have happened. 

In the hope to drastically reduce the time to find useful information in all these logs, I introduce my set-of-utilities called Azure Support Utilities, which integrate with the Windows Explorer Shell like so many great utilities out there (RFL, ETL2PCAP etc).

### Features:

1.	For a given time, Merges All events from all evtx files in a folder, sorted by time into a plain text file.

<ul><ul>This is useful when you want to just see what happened on a Windows VM in the event logs when a particular issue hit</ul></ul>

2.	For a given time, Merges Events that contain the keyword “Error” from all evtx files in a folder, sorted by time.

<ul><ul>This is useful when simply running through a pattern of errors</ul></ul>

3.	For a given time, Merges Events that contain user-supplied list of Keywords [REGEX] from all evtx files in a folder, sorted by time.

<ul><ul>This is useful when looking up events that may contain a keyword or keyword(s)</ul></ul>

4.	Performs a REGEX based keyword(s) search in all text-based files in a folder, recursively, into a plain text file with the filename, line number and line contents.

<ul><ul>This is useful when looking up lots of non-event-log files, and will work on Linux-VM’s Inspect IaaS disk, and searches a variety of files (txt, conf, log, xml, json,html, htm, ini etc.)</ul></ul>

Search results for each of the lookups are stored in the folder itself, in a uniquely named file that is not looked up if the search were to be repeated later.

For analysis of the text files, I recommend installing TextAnalysisTool.NET.

### To install: 
Just launch a <mark>NORMAL</mark> PowerShell window and run this command: 

`(iwr -Uri https://raw.githubusercontent.com/saibijee/AzureSupportTools/master/install.ps1 -UseBasicParsing).content | iex | out-null`


### To use: 

Right click the folder that contains the content/event logs/text logs and explore the options.
                
The tool self-updates on each run and also, I’ve built in some minimal telemetry to track usage, and am open to questions on that from anyone concerned. The telemetry is done by uploading a basic txt file that is name with the timestamp to a storage account. Further improvements are on its way.
