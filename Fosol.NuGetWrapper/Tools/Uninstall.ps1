param($installPath, $toolsPath, $package, $project) 
# $installPath	The path to the folder where the package is installed, by default $(solutionDir)\packages
# $toolsPath	The path to the \tools directory in the folder where the package is installed, by default, $(solutionDir)\packages\[packageId]-[version]\tools
# $package		A reference to the package object
# $project		A reference to the target EnvDTE project object.  This type is desribed on MSDN, http://msdn.microsoft.com/en-us/library/51h9a6ew(v=VS.80).aspx

Write-Host ("{0}{1}" -f "Running Uninstall.ps1 for ", $package)

.(Join-Path $toolsPath Fosol.NuGetWrapper.Props.ps1)
Import-Module (Join-Path $toolsPath Fosol.NuGetWrapper.psd1)

# Remove the .nuget folder from the solution.
function Remove-NuGetFolderFromSolution {
	try {
		$buildProject = $dte.Solution.Projects | Where { $_.ProjectName -eq $buildDirName }

		# Remove each installed file from the solution.
		foreach ($buildFile in $buildFiles) {
			$projectItem = $buildProject.ProjectItems | Where { $_.Name -eq $buildFile }
			Remove-ProjectItem($projectItem)
		}

		# Only remove the folder if it's empty.  If it has other files it means it belongs to something else.
		$isEmpty = Get-IsDirectoryEmpty($buildDir)
		if ($isEmpty -eq $true) {
			Remove-Project($buildProject)
		}
	}
	catch {
		Write-Error "Failed to remove '\.nuget\Fosol.NuGetWrapper.[version]\' folder and related files from the solution."
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
                Write-Warning "Failed to remove import '$projectHelperFileName' to $($project.Name)"
            }
        }
    }
}

function Main {
	Remove-NuGetFolderFromSolution
	Remove-NuSpecFile $project.Name
	Remove-ProjectHelper $project.Name
}

Main