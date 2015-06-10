param($installPath, $toolsPath, $package, $project) 
# $installPath	The path to the folder where the package is installed, by default $(solutionDir)\packages
# $toolsPath	The path to the \tools directory in the folder where the package is installed, by default, $(solutionDir)\packages\[packageId]-[version]\tools
# $package		A reference to the package object
# $project		A reference to the target EnvDTE project object.  This type is desribed on MSDN, http://msdn.microsoft.com/en-us/library/51h9a6ew(v=VS.80).aspx

Write-Host ("{0}{1}" -f "Running Uninstall.ps1 for ", $package)

Import-Module (Join-Path $toolsPath Fosol.NuGetWrapper.psd1)
.(Join-Path $toolsPath Fosol.NuGetWrapper.Props.ps1)

# Remove the .nuget folder from the solution.
function Remove-NuGetFolderFromSolution {
	try {
		$buildProject = $dte.Solution.Projects | Where { $_.ProjectName -eq $buildDirName }

		# Remove each installed file from the solution.
		foreach ($buildFile in $buildFiles) {
			$projectItem = $buildProject.ProjectItems | Where { $_.Name -eq $buildFile }
			Write-Host "Removing Project Item: $projectItem"
			Remove-ProjectItem($projectItem)
		}

		# Only remove the folder if it's empty.  If it has other files it means it belongs to something else.
		if ((Get-IsDirectoryEmpty($buildDir)) -eq $true) {
			Write-Host "Removing Project: $buildProject"
			Remove-Project($buildProject)
			Write-Host "Removing Item: $buildDir"
			Remove-Item $buildDir
		}

		# Only remove the .nuget folder if it's empty.  If it has other files it means it belongs to something else.
		if ((Get-IsDirectoryEmpty($buildRootDir)) -eq $true) {
			Write-Host "Removing Item: $buildRootDir"
			Remove-Item $buildRootDir
		}
	}
	catch {
		$errorMessage = $_.Exception.Message
		$itemName = $_.Exception.ItemName
		Write-Error "An error occured while attempting to remove '$itemName'. Error: $errorMessage"
	}
}

# Remove the nuget nuspec file created for the project.
function Remove-NuSpecFile {
    param(
        [parameter(ValueFromPipelineByPropertyName = $true)][string[]]$projectName
    )

	$projects = Resolve-ProjectName $projectName

	$projects | %{
		$project = $_
		$item = $project.ProjectItems | Where { $_.Name -eq "$($project.Name).nuspec" }

		if ($item) {
			Write-Host "Removing Item: $item"
			Remove-ProjectItem($item)
		}
	}
}

# Update the project XML to not include the Fosol.NuGetWrapper.csproj file.
function Remove-ProjectHelper {
    param(
        [parameter(ValueFromPipelineByPropertyName = $true)][string[]]$ProjectName
    )
    Process {
		$projects = Resolve-ProjectName $projectName
        
        $projects | %{ 
            $project = $_
            try {
				$projectPath = $project.FullName

                 if($project.Type -eq 'Web Site') {
                    Write-Warning "Skipping '$($project.Name)', Website projects are not supported"
                    return
                 }

				 Remove-Import $projectHelperFileName $project.Name
				 Write-Host "Project $($project.Name) has been updated to no longer import '$projectHelperFileName'"
            }
            catch {
				$errorMessage = $_.Exception.Message
				$itemName = $_.Exception.ItemName
				Write-Error "An error occured while attempting to remove '$itemName'. Error: $errorMessage"
                Write-Warning "Failed to remove import '$projectHelperFileName' to $($project.Name)"
            }
        }
    }
}

function Main {
	Write-Host "Starting uninstallation process."
	Remove-NuGetFolderFromSolution
	Remove-NuSpecFile $project.Name
	Remove-ProjectHelper $project.Name
	Write-Host "Completed uninstallation process."
}

Main