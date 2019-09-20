# list of servers and patch groups
$servers = Import-CSV C:\source\PesterInAction\Updates\AllInOne\servers.csv

# schedule for patch group
# days after patch tuesday
$patchGroupSchedule = @{
    Wave1 = 2
    Wave2 = 7
    Wave3 = 9
    Wave4 = 14
    Wave5 = 16  
}


# Get patch tuesday
$date = Get-Date

if($date.Hour -gt 6)
{
    Write-Verbose "Must be ran between midnight and 6AM"
    return
}
$monthStart = [datetime]::new($date.Year, $date.Month, 1)
$date.DayOfWeek - [System.DayOfWeek]::Tuesday

$secondTuesday = $monthStart.AddDays(7)
if ($secondTuesday.DayOfWeek -gt [System.DayOfWeek]::Tuesday) {
    $secondTuesday = $secondTuesday.AddDays($monthStart.DayOfWeek - [System.DayOfWeek]::Tuesday)
}
else {
    $secondTuesday = $secondTuesday.AddDays([System.DayOfWeek]::Tuesday - $monthStart.DayOfWeek)
}

$daysFromTuesday = [math]::floor(($date - $secondTuesday).TotalDays)

# Find Todays patch group
$patchGroup = foreach ($key in $patchGroupSchedule.Keys) {
    if ($daysFromTuesday -eq $patchGroupSchedule[$key]) {
        $key
    }
}

$serversToPatch = $servers | Where-Object Wave -eq $patchGroup
$namespace = 'root\ccm\clientSDK'
foreach ($computer in $serversToPatch) {
    $updates = Get-CimInstance -Namespace $namespace -ClassName CCM_SoftwareUpdates -ComputerName $computer
    if ($updates) {
        $updateSplat = @{
            
            ClassName =  "CCM_SoftwareUpdatesManager"
            Namespace = $namespace
            Name =  "InstallUpdates"
            Arguments =   $updates
            ComputerName =  $computer
        }
        Invoke-CimMethod @updateSplat
    }

}
