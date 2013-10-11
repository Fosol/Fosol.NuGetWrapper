param($installPath, $toolsPath, $package, $project) 
# $installPath	The path to the folder where the package is installed, by default $(solutionDir)\packages
# $toolsPath	The path to the \tools directory in the folder where the package is installed, by default, $(solutionDir)\packages\[packageId]-[version]\tools
# $package		A reference to the package object
# $project		A reference to the target EnvDTE project object.  This type is desribed on MSDN, http://msdn.microsoft.com/en-us/library/51h9a6ew(v=VS.80).aspx

Write-Host ("{0}{1}" -f "Running Install.ps1 for ", $package)

.(Join-Path $toolsPath Fosol.NuGetWrapper.Props.ps1)
Import-Module (Join-Path $toolsPath Fosol.NuGetWrapper.psd1)

#  Create a .nuget folder and copy the files into it.
function Add-BuildFolder($project) {
	if(!(Test-Path $buildDir)) {
		mkdir $buildDir | Out-Null
	}

	Write-Host "Copying $package files to $buildDir"
	foreach ($buildFile in $buildFiles) {
		Copy-Item "$toolsPath\$buildFile" $buildDir -Force | Out-Null
	}

	return "$buildDir"
}

# Update the solution to include the .nuget folder and the files in the folder.
function Update-Solution($buildDir) {
	# Get the open solution.
	$solution = Get-Interface $dte.Solution ([EnvDTE80.Solution2])

	# Create the solution folder.
	$buildProj = $solution.Projects | Where {$_.ProjectName -eq $buildDirName}
	if (!$buildProj) {
		$buildProj = $solution.AddSolutionFolder($buildDirName)
	}
	
	# Add files to build folder
	$projectItems = Get-Interface $buildProj.ProjectItems ([EnvDTE.ProjectItems])

	$filesInDir = [IO.Directory]::GetFiles($buildDir)
	foreach ($fileName in $filesInDir) {
		Write-Host "Adding $fileName to solution"
		$projectItems.AddFromFile($fileName)
	}
}

# Update the project XML to include an import to the Fosol.NuGetWrapper.csproj file.
function Add-ProjectHelper {
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

				 Add-Import $projectHelperFileName $project.Name
				 Write-Host "Project $($project.Name) has been updated to import '$projectHelperFileName'"
            }
            catch {
                Write-Warning "Failed to add import '$projectHelperFileName' to $($project.Name)"
            }
        }
    }
}

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
				$cmdArgs = @("spec", $project.Name)

				# Set the working directory to the project before executing nuget.exe spec.
				Push-Location $projectDir
				& "nuget" $cmdArgs | Out-Null
				Pop-Location
				
				# Add the nuspec file to the project.
				$filePath = Join-Path $projectDir "$($project.Name).nuspec"
				Write-Host "Adding $fileName to project $($project.Name)"
				$project.ProjectItems.AddFromFile($filePath)
			} catch {
				Write-Warning "Failed to add nuspec file to $($project.Name)"
			}
		}
	}
}

function Main {
	$buildDir = Add-BuildFolder $project
	Update-Solution $buildDir
	Add-ProjectHelper $project.Name
	Add-NuSpec $project.Name
	Write-Host "Don't forget to commit the .nuget folder"
}

Main