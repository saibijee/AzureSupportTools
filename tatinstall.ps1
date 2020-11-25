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
        
        # Create a Shortcut with Windows PowerShell
        $SourceFileLocation = "$TATOutputDir\TextAnalysisTool.NET.exe"
        $ShortcutLocation = "C:\Users\$ENV:Username\Desktop\TextAnalysisTool.NET.lnk"
        #New-Object : Creates an instance of a Microsoft .NET Framework or COM object.
        #-ComObject WScript.Shell: This creates an instance of the COM object that represents the WScript.Shell for invoke CreateShortCut
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
        $Shortcut.TargetPath = $SourceFileLocation
        #Save the Shortcut to the TargetPath
        $Shortcut.Save()
        
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
