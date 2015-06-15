# Fosol.NuGetWrapper 1.0.0.3
Fosol.NuGetWrapper provides a way for any project to automatically build its own NuGet package.

* Please note that updates to Fosol.NuGetWrapper will remove all installed pieces.  This means it will delete your customizations.  Please back them up before updating.

If you have a project that you would like to convert into a NuGet package install Fosol.NuGetWrapper and compile your project.
MSBuild will automatically create a 'Package' folder within your build target folder which will contain your NuGet package.

The default package created for your project will only contain your output target.
In the case of a 'Library' project the package will contain the appropriate assembly ([projectName.dll]).
In the case of an executable project the package will contain the appropriate compiled application.

You will need to manually update the default configuration so that other files are included in your package.
This requires that you update your project file and the "[projectName].nuspec" file to include additional files and information.

# Getting Started
It's as simple as installing the Fosol.NuGetWrapper package and building your project.

# Introduction
After installing Fosol.NuGetWrapper you can build your project and it will generate a NuGet package in the targeted output folder.

The process Fosol.NuGetWrapper follows to create your package is as follows;

1. Creates a 'Package' folder in the target output directory
2. Creates appropriate folders within the 'Package' folder (i.e. content, lib and tools)
3. Copy files from target output folder into the 'Package' folder if you have configured them to be included
4. Generate a nuspec file for the package based on your default "[projectName].nuspec" configuration file.  This uses the XSLT transform feature.
5. Build a NuGet package and place it in the 'Package' folder

### Package Manager Console Example
1. Open your solution/project in Visual Studio
2. Open the Package Manager Console
3. PM> Install-Package Fosol.NuGetWrapper

### Library Package Manager Tool
1. Open your solution/project in Visual Studio
2. In the "Tools" menu open the "Library Package Manager", then "Manage NuGet Packages for Solution..."
3. Search for "Fosol.NuGetWrapper"
4. Click "Install"

Now build your project and it will create a package in your target output directory (i.e. \bin\debug\Package\)

# Configuration
When you install Fosol.NuGetWrapper it will generated a NuSpec file named after your project, which is in your root project folder ("[projectName].nuspec").
You will need to update the nuspec file before building your project if you want the nuget package to be created.
If you want to include additional assemblies, files and content you will need to follow the NuGet documentation to add those items.  By default Fosol.NuGetWrapper
will include the compiled assembly for the project and all files in the following folders; build, content, lib, tools.

If you want to dynamically generate some of the nuspec file values add a PropertyGroup section within your project file and change the values.

If you want to add or remove files included in your nuget package you can update your project file and add a Target that runs before the NuGetBuild Target (see example below).
You will need to add this new Target after the import of the Fosol.NuGetWrapper.targets within your project file.

  <!-- This provides a way to add or remove files from the package. -->
  <Target Name="NuGetSetup" BeforeTargets="NuGetBuild">
    <Message Text="Setting up the NuGet Package files"/>
    <ItemGroup>
      <NuGetLib Remove="$(TargetPath)"/>
    </ItemGroup>
  </Target>

### PropertyGroup Section
The property group variables provide a way to control the build process; where files are copied and what values are used in the nuspec configuration.
    
    Variable Name							Default Value					Description    
    `````````````							`````````````                   ```````````
	NuGetWrapperId							Fosol.NuGetWrapper				Name of the Fosol.NuGetWrapper package.
    NuGetSpecXsltName						Fosol.NuGetWrapper.xslt         File used to transform the default nuspec file in your project.

	NuGetSpecExt							.nuspec							Extension for nuget spec file.
	NuGetPackageExt							.nupkg							Extension for nuget package file.
    
    NuGetSpecId								%(Asssembly.Name)               The id of your NuGet package.  If no value specified it will use your nuspec file value.
    NuGetSpecVersion						%(Asssembly.Version)            The version of your NuGet package.  If no value specified it will use your nuspec file value.
    NuGetSpecTitle							$(ProjectName)                  The title of your NuGet package.  If no value specified it will use your nuspec file value.
    NuGetSpecAuthors										                The authors of your NuGet package.  If no value specified it will use your nuspec file value.
    NuGetSpecOwners															The owners of your NuGet package.  If no value specified it will use your nuspec file value.
    NuGetSpecDescription													The description of your NuGet package.  If no value specified it will use your nuspec file value.
	NuGetSpecReleaseNotes													A Description of the current release.
	NuGetSpecSummary														A Short description of the NuGet package.
	NuGetSpecLanguage														The Language of the package.
	NuGetSpecProjectUrl														The URL to the project site.
	NuGetSpecIconUrl														The URL to an icon that identifies the package.
	NuGetSpecLicenseUrl														The URL to the license for the package.
	NuGetSpecCopyright														The Copyright description.
	NuGetSpecRequireLicenseAcceptance										Whether the license must be accepted before installation [yes|no]
	NuGetSpecDependencies													A list of dependencies (NOT IMPLEMENTED)
	NuGetSpecReferences														A list of references (NOT IMPLEMENTED)
	NuGetSpecFrameworkAssemblies											A list of framework assemblies (NOT IMPLEMENTED)
	NuGetSpecTags															A list of tags to identify the package for search.
	NuGetSpecDevelopmentDepency												A list of development depency (NOT IMPLEMENTED)
	
    NuGetOutDir								$(OutDir)Package\               Location of output directory that will contain the files which will be included in your package.
    
    
### ItemGroup Section
The item group variables provide a way to control what files are included in the NuGet package that will be built.
    
    Variable Name           Default Value							Description
    `````````````           `````````````							```````````
    NuGetBuild				$(OutDir)Build\**\*.*					The file(s) that will be included in the package "build" folder.
    NuGetContent            $(OutDir)Content\**\*.*					The file(s) that will be included in the package "content" folder.
    NuGetLib                $(TargetPath);$(OutDir)Lib\**\*.*		The file(s) that will be included in the package "lib" folder.
    NuGetTools              $(TargetPath);$(OutDir)Tools\**\*.*		The file(s) that will be included in the package "tools" folder.


## NuSpec Configuration
Fosol.NuGetWrapper automatically generates a default nuspec configuration file for your project.
It will be given the same name as your project "[projectName].nuspec" and will reside in the root project folder.
This nuspec configuration file is a default template which is used to generate the nuspec file that will be used to create your package.
When updating this file you will need to remember that the file locations will be relative to package output folder (see NuGetOutDir).
Refer to <http://docs.nuget.org/docs/reference/nuspec-reference> for more information on the nuspec configuration file.