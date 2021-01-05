#Master Template: https://raw.githubusercontent.com/dpaulson45/PublicPowerShellScripts/master/Functions/Get-ExchangeBuildNumberFromString/Get-ExchangeBuildNumberFromString.ps1
Function Get-ExchangeBuildNumberFromString {
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)][object]$AdminDisplayVersion 
    )
    #Function Version 1.0
    <# 
    Required Functions: 
        https://raw.githubusercontent.com/dpaulson45/PublicPowerShellScripts/master/Functions/Write-VerboseWriters/Write-VerboseWriter.ps1
    #>
    Write-VerboseWriter("Calling: Get-ExchangeBuildNumberFromString")
    Write-VerboseWriter("Passed: {0}" -f $AdminDisplayVersion.ToString())
    if($AdminDisplayVersion.GetType().Name -eq "string")
    {
        Write-VerboseWriter("AdminDisplayNumber string object detected. Converting into useable PSCustomObject")
        $versionNumber = (($AdminDisplayVersion.split("()") -replace "Version|Build","").split(".")).trim()
        Write-VerboseWriter("Trying to get local systems version number")
        $localVersionNumber = Get-Command ExSetup | ForEach-Object{$_.FileVersionInfo}

        $adminDisplayVersionObj = [PSCustomObject]@{
            Major = [int]$versionNumber[0]
            Minor = [int]$versionNumber[1]
            Build = [int]$versionNumber[2]
            Revision = [int]$versionNumber[3]
            LocalBuildNumber = $localVersionNumber.FileVersionRaw.ToString()
        }
    }
    else 
    {
        Write-VerboseWriter("Usable AdminDisplayNumber object passed. Nothing to do here")
        $adminDisplayVersionObj = $AdminDisplayVersion
    }
    
    return $adminDisplayVersionObj
}