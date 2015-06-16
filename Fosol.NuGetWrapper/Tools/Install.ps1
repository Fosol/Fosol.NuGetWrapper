param($installPath, $toolsPath, $package, $project) 
# $installPath	The path to the folder where the package is installed, by default $(solutionDir)\packages
# $toolsPath	The path to the \tools directory in the folder where the package is installed, by default, $(solutionDir)\packages\[packageId]-[version]\tools
# $package		A reference to the package object
# $project		A reference to the target EnvDTE project object.  This type is desribed on MSDN, http://msdn.microsoft.com/en-us/library/51h9a6ew(v=VS.80).aspx

Write-Host ("{0}{1}" -f "Running Install.ps1 for ", $package)

Import-Module (Join-Path $toolsPath Fosol.Core.MSBuild.psd1)

# Create and add a nuget nuspec file to the project.
function Add-NuSpec {
	param(
		[parameter(ValueFromPipelineByPropertyName = $true)][string[]]$projectName
	)

	# Execute nuget.exe nuspec on each project.
	Process {
		$projects = Resolve-ProjectName $projectName

		$projects | %{
			$project = $_
			try {
				$projectDir = Split-Path $project.FullName
				$fileName = "$projectName.nuspec"
				$filePath = Join-Path $projectDir $fileName
				$cmdArgs = @("spec", $projectName, "-Verbosity", "detailed", "-NonInteractive", "")
				
				Write-Host "Verfiying nuget nuspec file: $fileName"
				# Only create nuspec file if doesn't already exist.
				if (!(Test-Path $filePath)) {
					# Set the working directory to the project before executing nuget.exe spec.
					Push-Location $projectDir
					& "nuget.exe" $cmdArgs | Out-Null
					Pop-Location
				
					# Add the nuspec file to the project.
					Write-Host "Adding $fileName to project $projectName"
					$project.ProjectItems.AddFromFile($filePath)

					# Update the project file to include the nuspec file in the output.
					# $nuspec_config_item = $project.ProjectItems.Item($fileName)
					# $build_action = $nuspec_config_item.Properties.Item("BuildAction")
					# $build_action.Value = 2 # Content
					# $copy_to_output = $nuspec_config_item.Properties.Item("CopyToOutputDirectory")
					# $copy_to_output.Value = 2 # Copy if newer
				}
			} catch {
				$errorMessage = $_.Exception.Message
				$itemName = $_.Exception.ItemName
				Write-Error "An error occured while attempting to add '$itemName'. Error: $errorMessage"
				Write-Warning "Failed to add nuspec file to $projectName"
			}
		}
	}
}

function Main {
	Add-NuSpec $project.Name
	Write-Host "Don't forget to update the $($project.name).nuspec file with your package information before building."
}

Main