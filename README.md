# DTFindVersion
Daniele's Tools Find Version<br>
Finds version in passed line of text

### DESCRIPTION
This Powershell script parses input line of text and extracts the version part.
Version contained in passed line must be something like 1.2.3.4 or 1.2.3 or 1.2  or 1 or v1 or v1.2.3

### OUTPUTS
A hashtable with following keys:
- Start = first part of the line, before version
- Major = version's Major number
- Minor = version's Minor number (if any)
- Build = version's Build number (if any)
- Revision = version's Revision number (if any)
- End = last part of the line, after version
- The complete line (without a key)


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
