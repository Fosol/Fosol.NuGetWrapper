# Get the full path to the solution.
function Get-SolutionDirectory {
    if($dte.Solution -and $dte.Solution.IsOpen) {
        return Split-Path $dte.Solution.Properties.Item("Path").Value
    }
    else {
        throw "Solution not avaliable"
    }
}

function Get-ProjectPropertyValue {
    param(
        [parameter(Mandatory = $true)][string]$ProjectName,
        [parameter(Mandatory = $true)][string]$PropertyName
    )    
    try {
        $property = (Get-Project $ProjectName).Properties.Item($PropertyName)
        if($property) {
            return $property.Value
        }
    }
    catch {
    }
    return $null
}

function Resolve-ProjectName {
    param(
        [parameter(ValueFromPipelineByPropertyName = $true)][string[]]$ProjectName
    )
	
	if ($projectName) {
		$projects = Get-Project $projectName
	}
	else {
		$projects = Get-Project -All
	}

	if (!$projects) {
		Write-Error "Unable to locate project.  Make sure it isn't unloaded."
		return
	}

	return $projects
}

function Get-MSBuildProject {
    param(
        [parameter(ValueFromPipelineByPropertyName = $true)][string[]]$ProjectName
    )
    Process {
        (Resolve-ProjectName $ProjectName) | % {
            $path = $_.FullName
            @([Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($path))[0]
        }
    }
}

function Add-Import {
    param(
        [parameter(Position = 0, Mandatory = $true)][string]$Path,
        [parameter(Position = 1, ValueFromPipelineByPropertyName = $true)][string[]]$ProjectName
    )
    Process {
        (Resolve-ProjectName $ProjectName) | %{
            $buildProject = $_ | Get-MSBuildProject
            $buildProject.Xml.AddImport($Path)
            $_.Save()
        }
    }
}

function Remove-Import {
	param(
        [parameter(Position = 0, Mandatory = $true)][string]$Path,
        [parameter(Position = 1, ValueFromPipelineByPropertyName = $true)][string[]]$ProjectName
	)
	Process {
		(Resolve-ProjectName $ProjectName) | %{
			$buildProject = $_ | Get-MSBuildProject
			$import = $buildProject.Xml.Imports | Where-Object { $_.Project -like $Path }
			if ($import) {
				$import | ForEach-Object { $buildProject.Xml.RemoveChild($_) | Out-Null }
				$_.Save();
			}
		}
	}
}

function Set-MSBuildProperty {
    param(
        [parameter(Position = 0, Mandatory = $true)]$PropertyName,
        [parameter(Position = 1, Mandatory = $true)]$PropertyValue,
        [parameter(Position = 2, ValueFromPipelineByPropertyName = $true)][string[]]$ProjectName
    )
    Process {
        (Resolve-ProjectName $ProjectName) | %{
            $buildProject = $_ | Get-MSBuildProject
            $buildProject.SetProperty($PropertyName, $PropertyValue) | Out-Null
            $_.Save()
        }
    }
}

function Get-MSBuildProperty {
    param(
        [parameter(Position = 0, Mandatory = $true)]$PropertyName,
        [parameter(Position = 2, ValueFromPipelineByPropertyName = $true)][string]$ProjectName
    )
    
    $buildProject = Get-MSBuildProject $ProjectName
    $buildProject.GetProperty($PropertyName)
}

function Add-SolutionDirProperty {  
    param(
        [parameter(ValueFromPipelineByPropertyName = $true)][string[]]$ProjectName
    )
    
    (Resolve-ProjectName $ProjectName) | %{
        $buildProject = $_ | Get-MSBuildProject
        
         if(!($buildProject.Xml.Properties | ?{ $_.Name -eq 'SolutionDir' })) {
            # Get the relative path to the solution
            $relativeSolutionPath = [NuGet.PathUtility]::GetRelativePath($_.FullName, $dte.Solution.Properties.Item("Path").Value)
            $relativeSolutionPath = [IO.Path]::GetDirectoryName($relativeSolutionPath)
            $relativeSolutionPath = [NuGet.PathUtility]::EnsureTrailingSlash($relativeSolutionPath)
            
            $solutionDirProperty = $buildProject.Xml.AddProperty("SolutionDir", $relativeSolutionPath)
            $solutionDirProperty.Condition = '$(SolutionDir) == '''' Or $(SolutionDir) == ''*Undefined*'''
            $_.Save()
         }
     }
}

# Removes and deletes the specified project item from the project.
function Remove-ProjectItem {
	param(
		[parameter(Mandatory = $true)]$projectItem
	)
	if ($projectItem) {
		$fileName = $projectItem.FileNames(1)
		Write-Host ("Deleting {0} from project" -f $fileName)
		$projectItem.Remove()
		Remove-Item $fileName
	}
}

# Removes the project from the solution and then attempts to delete it.
function Remove-Project {
	param(
		[parameter(Mandatory = $true)]$project
	)
	if ($project) {
		try {
			# If it's an actual project object it will have a FullName value.
			if ($project.FullName) {
				Write-Host ("Deleting project '{0}' from solution." -f $project.Name)
				$projectDir = $project.FullName
				$dte.Solution.Remove($project)
			} else {
				# The $project is actually just the name of the folder in the solution.
				Write-Host ("Deleting folder '{0}' from solution." -f $project.Name)
				$projectDir = (Join-Path (Get-SolutionDirectory) $project.Name)
				$dte.Solution.Remove($project)
			}

			if ((Test-Path $projectDir)) {
				Remove-Item $projectDir
			}
		} catch {
			Write-Error "Failed to remove project '$($project.Name)' or its folder `"$projectDir`""
		}
	}
}

function Get-InstallPath {
    param(
        [parameter(Mandatory = $true)]$package
    )
    # Get the repository path
    $componentModel = Get-VSComponentModel
    $repositorySettings = $componentModel.GetService([NuGet.VisualStudio.IRepositorySettings])
    $pathResolver = New-Object NuGet.DefaultPackagePathResolver($repositorySettings.RepositoryPath)
    $pathResolver.GetInstallPath($package)
}

# Returns the package version information as a friendly string
function Format-PackageVersion {
	param(
		[parameter(Mandatory = $true)]$package,
		[string]$format = "{0}.{1}.{2}.{3}"
	)

	return ($format -f $package.Version.Version.Major, 
		$package.Version.Version.Minor, 
		$package.Version.Version.Build, 
		$package.Version.Version.Revision)
}

'Set-MSBuildProperty', 'Add-SolutionDirProperty', 'Add-Import', 'Remove-Import' | %{ 
    Register-TabExpansion $_ @{
        ProjectName = { Get-Project -All | Select -ExpandProperty Name }
    }
}

Register-TabExpansion 'Get-MSBuildProperty' @{
    ProjectName = { Get-Project -All | Select -ExpandProperty Name }
    PropertyName = {param($context)
        if($context.ProjectName) {
            $buildProject = Get-MSBuildProject $context.ProjectName
        }
        
        if(!$buildProject) {
            $buildProject = Get-MSBuildProject
        }
        
        $buildProject.Xml.Properties | Sort Name | Select -ExpandProperty Name -Unique
    }
}

Export-ModuleMember -Function Get-SolutionDirectory, 
	Get-ProjectPropertyValue, 
	Resolve-ProjectName, 
	Get-MSBuildProject, 
	Add-Import, 
	Remove-Import,
	Set-MSBuildProperty, 
	Get-MSBuildProperty, 
	Add-SolutionDirProperty, 
	Remove-ProjectItem, 
	Remove-Project, 
	Get-InstallPath,
	Format-PackageVersion