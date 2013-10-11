Write-Host "Imported Fosol.NuGetWrapper.Props.ps1"

$buildFiles = @(
	"Fosol.NuGetWrapper.targets", 
	"Fosol.NuGetWrapper.xslt", 
	"Fosol.NuGetWrapper.ReadMe.md")

$buildDirName = ".nuget"
$buildDir = (Join-Path (Get-SolutionDirectory) $buildDirName)
$projectHelperFileName = "Fosol.NuGetWrapper.csproj"