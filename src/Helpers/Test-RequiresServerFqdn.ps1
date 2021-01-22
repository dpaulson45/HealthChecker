Function Test-RequiresServerFqdn {

    Write-VerboseOutput("Calling: Test-RequiresServerFqdn")
    try
    {
        $tempServerName = ($Script:Server).Split(".")

        if($tempServerName.count -gt 1)
        {
            Write-VerboseOutput("Fqdn was passed using '-server' parameter")
            $isFqdn = $true
            $connectionMethod = "Fqdn"
        }
        else
        {
            Write-VerboseOutput("NetBIOS name was passed using '-server' parameter")
            $connectionMethod = "NetBIOS name"
            $Script:ServerFQDN = (Get-ExchangeServer $Script:Server).FQDN
        }

        if($tempServerName[0] -eq $env:COMPUTERNAME)
        {
            Write-VerboseOutput("Executed against the local machine. No need to pass '-ComputerName' parameter.")
        }
        else
        {
            try
            {
                Invoke-Command -ComputerName $Script:Server -ScriptBlock {Get-Date | Out-Null} -ErrorAction Stop
                Write-VerboseOutput("Connected successfully using: {0}." -f $connectionMethod)
            }
            catch
            {
                Invoke-CatchActions
                if($isFqdn)
                {
                    $newConnectionMethod = "NetBIOS name"
                    $Script:Server = $tempServerName[0]
                }
                else
                {
                    $newConnectionMethod = "Fqdn"
                    $Script:Server = $Script:ServerFQDN
                }
                Write-VerboseOutput("Failed to connect to: {0} using {1}. Fallback to: {2}" -f $Script:Server, $connectionMethod, $newConnectionMethod)
            }
        }
    }
    catch
    {
        Invoke-CatchActions
        Write-VerboseOutput("Failed to successfully run 'Test-RequiresServerFqdn'")
    }
}