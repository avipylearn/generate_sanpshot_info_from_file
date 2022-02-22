Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false | Out-Null
Disconnect-VIServer -Force -confirm:$false -ErrorAction SilentlyContinue

$vcenter = Read-Host "Enter vCenter IP or FQDN"
$user = Read-Host "Enter vCenter Username"
$passw = Get-Credential -UserName $user -Message "Enter password"


try
{
    Connect-VIServer $vcenter -ErrorAction Stop -Credential $passw -wa 0 | Out-Null
}
catch [VMware.VimAutomation.ViCore.Types.V1.ErrorHandling.InvalidLogin]
{
    Write-Host "Cannot connect to $vcenter with provided credentials" -ForegroundColor Red
    break
}
catch [VMware.VimAutomation.Sdk.Types.V1.ErrorHandling.VimException.ViServerConnectionException]
{
    Write-Host "Cannot connect to $vcenter - check IP/FQDN" -ForegroundColor Red
    break
}
catch
{
    Write-Host "Cannot connect to $vcenter - Unknown error" -ForegroundColor Red
    break
}

$csv = Import-Csv ".\input_files\create_snapshot.csv"

#Create snapshots with name and description. Set async as desired.
foreach ($name in $csv)
{
    New-Snapshot -VM $name.Name -Name "testing" -Description "Sample snapshot" -confirm:$false -runasync:$true -memory:$true -quiesce:$true | Out-Null
}

Disconnect-VIServer -Force -confirm:$false -ErrorAction SilentlyContinue
Write-Host "Snapshots taken"
