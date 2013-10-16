Write-Host "Imported Fosol.NuGetWrapper.Props.ps1"

$buildFiles = @(
	"Fosol.NuGetWrapper.targets", 
	"Fosol.NuGetWrapper.xslt", 
	"Fosol.NuGetWrapper.README.md")

$packageVersion = Format-PackageVersion $package
$buildRootDirName = ".nuget"
$buildRootDir = (Join-Path(Get-SolutionDirectory) $buildRootDirName)
$buildDirName = "$($package.Id)"
$buildDir = (Join-Path $buildRootDir $buildDirName)
$projectHelperFileName = "Fosol.NuGetWrapper.csproj"