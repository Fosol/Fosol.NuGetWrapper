Write-Host "Imported Fosol.NuGetWrapper.Props.ps1"

$buildFiles = @(
	"Fosol.NuGetWrapper.targets", 
	"Fosol.NuGetWrapper.xslt", 
	"Fosol.NuGetWrapper.ReadMe.md")

$packageVersion = Format-PackageVersion $package
$buildRootDirName = ".nuget"
$buildDirName = "$($package.Id).$($packageVersion)"
$buildRootDir = (Join-Path(Get-SolutionDirectory) $buildRootDirName)
$buildDir = (Join-Path $buildRootDir $buildDirName)
$projectHelperFileName = "Fosol.NuGetWrapper.csproj"