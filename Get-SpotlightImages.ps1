$files = Get-ChildItem $Env:LocalAppData\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets |
    Where-Object Length -gt 1kb
if ($files) {
    $shell = New-Object -ComObject Shell.Application
    $folder = "$Env:USERPROFILE\OneDrive\Pictures\Wallpaper\Spotlight"
    if (!(Test-Path $folder)) { mkdir $folder }
    $files | % {
        $_ | Copy-Item -Destination $folder\$_.jpg
        Get-Item $folder\$_.jpg
    } | % {
        $namespace = $shell.namespace($folder)
        $item = $namespace.ParseName($_.Name)
        $size = $namespace.GetDetailsOf($item, 31)
        if ($size -match '(\d+) x (\d+)') {
            $width = [int]($Matches[1])
            $height = [int]($Matches[2])
        }
        if (!$size -or $width -lt 500 -or $height -lt 500 -or $width -lt $height) {
            Remove-Item $_
        }
    }
}