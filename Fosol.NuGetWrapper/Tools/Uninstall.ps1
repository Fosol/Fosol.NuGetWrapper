param($installPath, $toolsPath, $package, $project) 
# $installPath	The path to the folder where the package is installed, by default $(solutionDir)\packages
# $toolsPath	The path to the \tools directory in the folder where the package is installed, by default, $(solutionDir)\packages\[packageId]-[version]\tools
# $package		A reference to the package object
# $project		A reference to the target EnvDTE project object.  This type is desribed on MSDN, http://msdn.microsoft.com/en-us/library/51h9a6ew(v=VS.80).aspx

Write-Host ("{0}{1}" -f "Running Uninstall.ps1 for ", $package)

Import-Module (Join-Path $toolsPath Fosol.Core.MSBuild.psd1)
