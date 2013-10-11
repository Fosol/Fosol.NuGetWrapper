# Check if the directory is empty.
function Get-IsDirectoryEmpty($path) {
	$dirInfo = Get-ChildItem $path | Measure-Object
	if ($dirInfo.Count -eq 0) {
		return $true
	}

	return $false
}

Export-ModuleMember -Function Get-IsDirectoryEmpty