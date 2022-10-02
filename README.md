# DT Find Version
Daniele's Tools Find Version<br>
Finds version in passed text line or text file.

### DESCRIPTION
Finds versions in line of text, or text files, corresponding to Major.Minor.Build.Revision pattern.<br>
This Powershell module has 2 functions:

#### Find-VersionInLine:
Parses input line of text and extracts the version part.<br>
Version contained in passed line must be something like:<br>
1.2.3.4 or 1.2.3 or 1.2 or 1.2 or v1.2 or v1.2.3

OUTPUTS<br>
An array composed of:
- [0] = first part of the line, before version
- [1] = a Version object
- [2] = last part of the line, after version

#### Find-VersionInFile
Parses input text file and extracts all Versions found in lines that contain the passed VersionKeyword.

OUTPUTS<br>
See above Find-VersionInLine

### EXAMPLE
In the line:
```
[assembly: AssemblyVersion(""1.2.3.4"")]
```
the version is:
```
1.2.3.4
```

In the line:
```
<FileVersion>v1.2.3</FileVersion>
```
the version is:
```
1.2.3
```
