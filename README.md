# DT Find Version
Daniele's Tools Find Version<br>
Finds and updates version in text line or text file.

### DESCRIPTION
If -Line is passed:<br>
    Parses input line of text and extracts or updates the version part.<br>
    Version contained in Line must follow Major.Minor[.Build[.Revision]] pattern, e.g.: 1.2.3.4 or 1.2.3 or 1.2.<br>

If -FilePath is passed:<br>
    Parses input text file and extracts or updates all versions found in lines that contain -VersionKeyword.<br>

If -Increment or -Generate is used, version will be updated accordingly.<br>
- -Increment, if present, can have a value among Major, Minor, Build or Revision to increment it when found.<br>
- -Generate, if present, can have a value of Build, Revision or BuildAndRevision to generate a version number based on today's date and time, and write it in the Build part, Revision part, or both, respectively.

### EXAMPLE

Read a version in input line:
```
PS C:\> Find-Version -Line "Version 1.2.3"

Major  Minor  Build  Revision
-----  -----  -----  --------
1      2      3      -1
Version 1.2.3
```

Increment build number in input line:
```
PS C:\> Find-Version -Line "Version 1.2.3" -Increment Build

Major  Minor  Build  Revision
-----  -----  -----  --------
1      2      4      -1
Version 1.2.4
```

Find version in csproj file:
```
PS C:\> Find-Version -FilePath .\Tests\Net60-Test.csproj -VersionKeyword AssemblyVersion

Name                           Value
----                           -----
Version                        1.2.3
Line                           <AssemblyVersion>1.2.3</AssemblyVersion>
```

Increment version in my csproj file:
```
PS C:\> Find-Version -FilePath .\Tests\Net60-Test.csproj -VersionKeyword AssemblyVersion -Increment Build
New AssemblyVersion: 1.2.4
```

Generate version number based on today's date and time:
```
PS C:\> Find-Version -FilePath .\Tests\Net60-Test.csproj -VersionKeyword AssemblyVersion -Generate BuildAndRevision
New AssemblyVersion: 1.3.278.3769
```


