Function Test-RequiresServerFqdn {

    Write-VerboseOutput("Calling: Test-RequiresServerFqdn")
    try
    {
        $Script:ServerFQDN = (Get-ExchangeServer $Script:Server).FQDN
        if($Script:Server -ne $env:COMPUTERNAME)
        {
            Invoke-Command -ComputerName $Script:Server -ScriptBlock {Get-Date | Out-Null} -ErrorAction Stop
            Write-VerboseOutput("Connected successfully using NetBIOS name.")
        }
        else
        {
            Write-VerboseOutput("Executed against the local machine. No need to pass '-ComputerName' parameter.")
        }
    }
    catch
    {
        Invoke-CatchActions
        Write-VerboseOutput("Failed to connect to {0} using NetBIOS name. Fallback to Fqdn: {1}" -f $Script:Server, $Script:ServerFQDN)
        $Script:Server = $Script:ServerFQDN
    }
}