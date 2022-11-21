# Daniele's Tools Find-Version
DTFindVersion<br>
Finds and updates versions in text line or text file, source code.<br>
Copyright (C) 2022 Daniznf

### DESCRIPTION
If -Line is passed:
- Parses input line of text and extracts or updates the version part

If -FilePath is passed:
- Parses input text file and extracts or updates all versions found in lines that contain VersionKeyword<br>

If -Increment or -Generate is used, version will be updated accordingly:
- -Increment, if present, can be a value between "Major", "Minor", "Build" and "Revision" to increment it when found
- -Generate, if present, can be a value between "Build", "Revision" and "BuildAndRevision" to generate a version number based on today's date and time, and write it in the Build part, Revision part, or both, respectively. When using "Build" or "Revision", the generated number is lower than 65535 if elapsed time is lower than 45 days and 12 hours, so -DayOffset could be useful in this case.

Versions to be found or updated must follow Major.Minor[.Build[.Revision]] pattern, e.g.: "1.2.3.4" or "1.2.3" or "1.2"
with any word before or after, e.g: "version 1.2" or "v1.2.3" or "\<version\>1.2.3\</version\>", etc.

### EXAMPLE

Read version in input line:
```
PS C:\> Find-Version -Line "Version 1.2.3"
```
Will return a Version object and the original line.
```
Major  Minor  Build  Revision
-----  -----  -----  --------
1      2      3      -1
Version 1.2.3
```

### EXAMPLE
Increment Build number in input line:
```
PS C:\> Find-Version -Line "Version 1.2.3" -Increment Build
```
Will return an updated Version object with Build incremented by 1, and the modified line.
```
Major  Minor  Build  Revision
-----  -----  -----  --------
1      2      4      -1
Version 1.2.4
```

### EXAMPLE
Find version in csproj file:
```
PS C:\> Find-Version -FilePath .\Tests\Net60-Test.csproj -VersionKeywords AssemblyVersion
```
Will return all Version objects extracted from lines that contain "AssemblyVersion", and all the corresponding lines.
```
Name                           Value
----                           -----
Version                        1.2.3
Line                           <AssemblyVersion>1.2.3</AssemblyVersion>
```

### EXAMPLE
Increment Build number in csproj file:
```
PS C:\> Find-Version -FilePath .\Tests\Net60-Test.csproj -VersionKeywords AssemblyVersion -Increment Build
```
Will update the file (making a backup before) updating all lines that contain "AssemblyVersion" incrementing Build part by 1. All updates will also be written to output.
```
New version 1.2.4
```

### EXAMPLE
Generate version number based on today's day and time:
```
PS C:\> Find-Version -FilePath .\Tests\Net60-Test.csproj -VersionKeywords AssemblyVersion -Generate BuildAndRevision
```
Will update the file (making a backup before) updating all lines that contain "AssemblyVersion" generating new Build and Revision numbers. All updates will also be written to output.
```
New version 1.2.278.3769
```

### EXAMPLE
Update dotNET project's version at every build.
In Visual Studio's pre-build event, just call Find-Version with needed parameters.
If more than one file is to be updated, just call Find-Version as many times as needed.
```
Powershell -ExecutionPolicy ByPass "Find-Version" "-FilePath '$(ProjectDir)\MyProject.csproj' -Generate Build -VersionKeywords 'ApplicationDisplayVersion','AssemblyVersion','FileVersion' -DayOffset -300"
```

### Install
Run DTInstallModule.ps1 in DTFindVersion directory (https://github.com/daniznf/DTInstallModule), or copy module directory into one of directories in $env:PSModulePath.

### Uninstall
Delete DTFindVersion directory from the one you chose in $env:PSModulePath.

All product names, logos and brands are property of their respective owners.