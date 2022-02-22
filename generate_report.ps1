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

$csv = Import-Csv ".\input_files\vms.csv"

$not_exist = @("Name")
$has_snap= @("Name")
$no_snap = @("Name")
$htable = @{ }

foreach ($name in $csv.Name)
{
    $exists = Get-VM $name -ErrorAction SilentlyContinue
    if ($exists)
    {
        if (Get-Snapshot $name)
        {
            $has_snap += $name + " - " + (Get-Snapshot $name| Select-Object -ExpandProperty Name)
            $htable.add("$name", "Has Snapshot")
        }
        else
        {
            $no_snap += "$name" 
            $htable.add("$name", "No Snapshot")
        }
    }
    else
    {
        $not_exist += "$name"
        $htable.add("$name", "Does not exist")
    }
}

$no_snap | Out-File -FilePath .\Reports\no_snapshot.csv
$has_snap | Out-File -FilePath .\Reports\has_snapshot.csv
$not_exist | Out-File -FilePath .\Reports\not_exist.csv

$htable.GetEnumerator() | Select-Object Name, Value | Export-Csv .\Reports\all_vms.csv

Disconnect-VIServer -Force -confirm:$false -ErrorAction SilentlyContinue
Write-Host "Reports generated"
