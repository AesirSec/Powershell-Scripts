function ClearCCM { 

$resman= New-Object -ComObject "UIResource.UIResourceMgr"
$cacheInfo=$resman.GetCacheInfo()
Function GetList{
$PackagesCache = $cacheInfo.GetCacheElements() | Where-Object { $_.ContentID | Select-String -Pattern '^\w{8}$' }

Write-Output ""
Write-Output "-----------------------------------"
Write-Output "Reporting Packages in Cache | Count: $(($PackagesCache.ReferenceCount).Count)"
Write-Output ""

foreach ($Package in $PackagesCache)
    {
    $PackageInfo = Get-CimInstance -Namespace root/ccm/Policy/Machine/ActualConfig -ClassName CCM_SoftwareDistribution -Filter "PKG_PackageID = '$(($Package).ContentId)'"
    if ($PackageInfo.PKG_Name -eq $null)
        {
        $CMCacheObjects.GetCacheElements() | Where-Object {$_.ContentID -eq $($Package.ContentId) } | ForEach-Object {$CMCacheObjects.DeleteCacheElement($_.CacheElementID)}
        }
    else
        {
        if ($PackageInfo.Count -ge 1){Write-Output "Name: $($PackageInfo[0].PKG_Name)"}
        else {Write-Output "Name: $($PackageInfo.PKG_Name)"}
        Write-Output "Package ID: $($Package.ContentId)"
        Write-Output "Cache Location: $($Package.Location)"
        Write-Output "Cache Size: $($Package.ContentSize)"
        Write-Output "__"
        }
    }
    }

GetList
Write-Output "`nClearing CCM Cache Contents"
$cacheinfo.GetCacheElements()  | foreach {$cacheInfo.DeleteCacheElement($_.CacheElementID)}
Start-Sleep 5
Write-Output "`nContents Cleared"
GetList
    }
$Cred = Get-Credential
Add-Type -AssemblyName Microsoft.VisualBasic
$computer = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a computer name", "Computer")
$session = New-PSSession -ComputerName $computer -Credential $Cred
Invoke-Command -Session $session -ScriptBlock ${function:ClearCCM}
Disconnect-PSSession $session


Read-Host -Prompt "Press Enter to exit"