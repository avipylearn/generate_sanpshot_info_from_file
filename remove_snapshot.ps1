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

$csv = Import-Csv ".\input_files\remove_snapshot.csv"

#Remove snapshots with specified name
foreach ($name in $csv.Name)
{
    Get-VM $name | Get-Snapshot -Name "testing" | Remove-Snapshot -confirm:$false -runasync:$true | Out-Null
}

Disconnect-VIServer -Force -confirm:$false -ErrorAction SilentlyContinue
Write-Host "Snapshots removed"
