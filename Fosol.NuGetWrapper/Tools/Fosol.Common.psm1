# Check if the directory is empty.
function Get-IsDirectoryEmpty($path) {
	$items = Get-ChildItem $path -Force
	if ($items.Count -eq 0) {
		return $true
	}

	return $false
}

Export-ModuleMember -Function Get-IsDirectoryEmpty