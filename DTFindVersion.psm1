<#
    Daniele's Tools Find Version
    Copyright (C) 2022 Daniznf

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

    https://github.com/daniznf/DTFindVersion
#>

function Find-VersionInLine
{
    param (
        [Parameter(Mandatory)]
        [string]
        $Line
    )

    $Version = $null
    $Found = $Line -match "(?<Start>\D*)(?<Major>\d+)\.(?<Minor>\d+)\.?(?<Build>\d+)?\.?(?<Revision>\d+)?(?<End>\D*)"

    if ($Found)
    {
        if ($Matches["Major"] -and $Matches["Minor"])
        {
            if ($Matches["Build"])
            {
                if ($Matches["Revision"])
                {
                    $Version = [Version]::new($Matches["Major"], $Matches["Minor"], $Matches["Build"], $Matches["Revision"])
                }
                else
                {
                    $Version = [Version]::new($Matches["Major"], $Matches["Minor"], $Matches["Build"])
                }
            }
            else
            {
                $Version = [Version]::new($Matches["Major"], $Matches["Minor"])
            }
        }
    }

    if ($Version)
    {
        return $Matches["Start"], $Version, $Matches["End"]
    }
    else
    {
        return $null
    }

    <#
    .SYNOPSIS
        Finds version in Line.

    .DESCRIPTION
        Parses input line of text and extracts the version part.
        Version contained in Line must follow Major.Minor[.Build[.Revision]] pattern, e.g.:
        1.2.3.4 or 1.2.3 or 1.2

    .PARAMETER Line
        Line to scan.

    .OUTPUTS
        An array composed of:
        - [0] = first part of the line, before version
        - [1] = a version object
        - [2] = last part of the line, after version
    #>
}

function Update-Version {
    param (
        [Parameter(Mandatory)]
        [Version]
        $Version,

        [Parameter(Mandatory, ParameterSetName="Increment")]
        [ValidateSet("Major", "Minor", "Build", "Revision")]
        [string]
        $Increment,

        [Parameter(Mandatory, ParameterSetName="Date")]
        [ValidateSet("BuildAndRevision", "Build", "Revision")]
        [string]
        $Date,

        [Parameter(ParameterSetName="Date")]
        [int]
        $DayOffset,

        [Parameter(Mandatory, ParameterSetName="Date")]
        [datetime]
        $Now
    )

    $NewMajor = $Version.Major
    $NewMinor = $Version.Minor
    $NewBuild = $Version.Build
    $NewRevision = $Version.Revision

    $HasBuild = $Version.Build -gt -1
    $HasRevision = $Version.Revision -gt -1

    if ($Increment)
    {
        if ($Increment -eq "Major") { $NewMajor++ }
        if ($Increment -eq "Minor") { $NewMinor++ }
        if ($Increment -eq "Build" -and $HasBuild) { $NewBuild++ }
        if ($Increment -eq "Revision" -and $HasRevision) { $NewRevision++ }
    }
    elseif ($Date)
    {
         # Max 365
         $DayPart = ($Now).DayOfYear + $DayOffset
         if ($DayPart -lt 0) { $DayPart = 0 }

         # Max 86400 / 10
         $SecondPart = ($Now).Hour * 60 * 60 + ($Now).Minute * 60 + ($Now).Second
         $SecondPart = [System.Math]::Round($SecondPart / 10)

         if (($Date -eq "Build") -and (-not ($Date -eq "Revision")))
         {
             $NewBuild = $DayPart * 10000 + $SecondPart

             if ($HasRevision) { $NewRevision = $Version.Revision }
         }
         elseif ((-not ($Date -eq "Build")) -and ($Date -eq "Revision"))
         {
             if ($HasBuild)  { $NewBuild = $Version.Build }
             else { $NewBuild = 0}

             $NewRevision = $DayPart * 10000 + $SecondPart
         }
         else # $Date -eq "BuildAndRevision"
         {
             $NewBuild = $DayPart
             $NewRevision = $SecondPart
         }
    }

    # Version always has Major and Minor.
    if ($HasBuild)
    {
        if ($HasRevision) { $NewVersion = [version]::new($NewMajor, $NewMinor, $NewBuild, $NewRevision) }
        else { $NewVersion = [version]::new($NewMajor, $NewMinor, $NewBuild) }
    }
    else { $NewVersion = [version]::new($NewMajor, $NewMinor) }

    return $NewVersion


    <#
    .SYNOPSIS
        Updates version.

    .DESCRIPTION

    .PARAMETER Version
        Version object to update.

    .PARAMETER Increment
        Value to increment.

    .PARAMETER Date
        Generate a new version number for Build or Revision, or both.
        If -Date is Build, the number will be written in Build part.
        If -Date is Revision, the number will be written in Revision part.
        If -Date is BuildAndRevision, Build will contain "day" part and
        Revision will contain "second" part.

    .PARAMETER DayOffset,
        A positive or negative number to add to the "day" part of the date algorithm.

    .PARAMETER Now
        A Datetime used to generate Date number, retrieved before calling this function.

    .OUTPUTS
        A new Version with updated values.
    #>
}

function Select-Language {
    param (
        [Parameter(Mandatory)]
        [string]
        $FilePath
    )

    $Language = $null

    if ($FilePath.Contains("."))
    {
        $FileExtension = $FilePath.Substring($FilePath.LastIndexOf(".") +1)

        switch ($FileExtension)
        {
            "cs" { $Language = "cs"; break }
            "xml" { $Language = "xml"; break }
            "csproj" { $Language = "xml"; break }
            "js" { $Language = "js"; break }
            "ps1" { $Language = "ps"; break }
            "psm1" { $Language = "ps"; break }
            "psd1" { $Language = "ps"; break }
            "vb" { $Language = "vb"; break }
            "bat" { $Language = "bat"; break }
            Default { $Language = $null }
        }
    }

    return $Language


    <#
    .SYNOPSIS
        Guesses Language of file, based on file extension.

    .OUTPUTS
        A string corresponding to language.
    #>
}


function Find-VersionInFile
{
    param (
        [Parameter(Mandatory, ParameterSetName="Find")]
        [Parameter(Mandatory, ParameterSetName="Increment")]
        [Parameter(Mandatory, ParameterSetName="Date")]
        [string]
        $FilePath,

        [Parameter(ParameterSetName="Find")]
        [Parameter(ParameterSetName="Increment")]
        [Parameter(ParameterSetName="Date")]
        [string]
        $VersionKeyword,

        [Parameter(ParameterSetName="Find")]
        [Parameter(ParameterSetName="Increment")]
        [Parameter(ParameterSetName="Date")]
        [ValidateSet("cs", "xml", "js", "ps", "vb", "bat")]
        [string]
        $Language,

        [Parameter(Mandatory, ParameterSetName="Increment")]
        [ValidateSet("Major", "Minor", "Build", "Revision")]
        [string]
        $Increment,

        [Parameter(Mandatory, ParameterSetName="Date")]
        [ValidateSet("BuildAndRevision", "Build", "Revision")]
        [string]
        $Date,

        [Parameter(ParameterSetName="Date")]
        [int]
        $DayOffset,

        [Parameter(ParameterSetName="Increment")]
        [Parameter(ParameterSetName="Date")]
        [Alias("DryRun")]
        [switch]
        $WhatIf
    )

    # Get a datetime now so all updates will have the same version number.
    if ($Date) { $Now = Get-Date }

    $Versions = [System.Collections.ArrayList]::new()

    if ( -not (Test-Path $FilePath)) { throw [System.IO.FileNotFoundException]::new("Could not find $FilePath") }

    # Language is needed to understand file read below.
    if (-not $Language)
    {
        $SelectedLanguage = Select-Language -FilePath $FilePath

        if ($SelectedLanguage)
        {
            $Language = $SelectedLanguage
            Write-Verbose "File language has been automatically set to $Language."
        }
        else { Write-Verbose "Could not select file language!" }
    }

    # Use Language to understand code comments.
    $Comment, $CommentStart, $CommentEnd, $CutOffset = $null
    switch ($Language)
    {
        { $_ -in "cs", "js" }
        {
            $Comment = "//"
            $CommentStart = "/*"
            $CommentEnd = "*/"
            break
        }
        "xml"
        {
            $CommentStart = "<!--"
            $CommentEnd = "-->"
            break
        }
        "ps"
        {
            $Comment = "#"
            $CommentStart = "<#"
            $CommentEnd = "#>"
            break
        }
        "vb"
        {
            $Comment = "'"
            break
        }
        "bat"
        {
            $Comment = "REM"
            break
        }

        Default { }
    }

    # $CutOffset is needed when $CommentEnd is longer than 1 char, like "-->" .
    if ($CommentEnd) { $CutOffset = $CommentEnd.Length }

    # Make a backup if file is going to be updated.
    if ($Increment -or $Date)
    {
        $FilePathBak = $FilePath + ".bak"
        Write-Verbose "Creating backup in $FilePathBak"
        if (-not $WhatIf)
        {
            $null = Move-Item -Path $FilePath -Destination $FilePathBak -Force -ErrorAction Stop
            $null = New-Item -Path $FilePath -ItemType File
        }

        $FileContent = Get-Content $FilePathBak
    }
    else
    {
        $FileContent = Get-Content $FilePath
    }

    # If file is 1 line long, $FileContent will be string, but an Array is needed.
    if ($FileContent -is [string]) { $FileContent = @($FileContent) }

    for ($i = 0; $i -lt $FileContent.Length; $i++)
    {
        $Start, $Version, $End = $null
        $IgnoredBefore, $IgnoredMiddle, $IgnoredAfter = $null
        $Cut, $CutStart, $CutEnd = -1
        $OrLine = $FileContent[$i]
        $Line = $OrLine

        if (($null -eq $VersionKeyword) -or ($OrLine.Contains($VersionKeyword)))
        {
            # Remove comments from $Line, and then parse it to find a version.

            # Multi-line comments.
            if ($CommentStart -and $CommentEnd)
            {
                # Some languages do not have $CommentStart and $CommentEnd.
                $CutStart = $OrLine.IndexOf($CommentStart)
                $CutEnd = $OrLine.IndexOf($CommentEnd)
                if ($CutStart -gt -1)
                {
                    if ($CutEnd -gt -1)
                    {
                        if ($CutEnd -gt $CutStart)
                        {
                            if ($OrLine.Trim().IndexOf($CommentStart) -eq 0)
                            {
                        #       <# comment #> Version
                                $Line = $OrLine.Substring($CutEnd + $CutOffset)
                                $IgnoredBefore = $OrLine.Substring(0, $CutEnd + $CutOffset)
                            }
                            elseif ($OrLine.Trim().IndexOf($CommentEnd) -eq ($OrLine.Trim().Length - $CutOffset))
                            {
                        #       Version <# comment #>
                                $Line = $OrLine.Substring(0, $CutStart)
                                $IgnoredAfter = $OrLine.Substring($CutStart)
                            }
                            else
                            {
                        #       Version <# comment #> Version
                                $Line = $OrLine.Substring(0, $CutStart)
                                $IgnoredMiddle = $OrLine.Substring($CutStart, ($CutEnd + $CutOffset - $CutStart))
                                $Line += $OrLine.Substring($CutEnd + $CutOffset)
                            }
                        }
                        else
                        {
                    #       comment#> Version <# comment
                            $Line = $OrLine.Substring($CutEnd + $CutOffset, ($CutStart - $CutEnd - $CutOffset))
                            $IgnoredBefore = $OrLine.Substring(0, $CutEnd + $CutOffset)
                            $IgnoredAfter = $OrLine.Substring($CutStart)
                        }
                    }
                    else
                    {
                #       Version <# comment
                        $Line = $OrLine.Substring(0, $CutStart)
                        $IgnoredAfter = $OrLine.Substring($CutStart)
                    }
                }
                else
                {
                    if ($CutEnd -gt -1)
                    {
                #       comment #> Version
                        $Line = $OrLine.Substring($CutEnd + $CutOffset)
                        $IgnoredBefore = $OrLine.Substring(0, $CutEnd + $CutOffset)
                    }
                }
            }

            # Single Line Comment.
            if ($Comment)
            {
                $Cut = $OrLine.IndexOf($Comment)

                if (($Cut -gt -1) -and ($CutStart -eq -1) -and ($CutEnd -eq -1))
                {
            #       Version # comment
                    $Line = $OrLine.Substring(0, $Cut)
                    $IgnoredAfter = $OrLine.Substring($Cut)
                }
            }

            # $Line is now clean. But it could be empty if all line was a comment with a $VersionKeyword within.
            if ($Line)
            {
                $Start, $Version, $End = Find-VersionInLine -Line $Line
                if ($Version)
                {
                    if ($Increment -or $Date)
                    {
                        $UpdateParams = @{ "Version" = $Version }

                        if ($Increment) { $UpdateParams.Add("Increment", $Increment) }

                        if ($Date)
                        {
                            $UpdateParams.Add("Date", $Date)
                            $UpdateParams.Add("Now", $Now)

                            if ($DayOffset) { $UpdateParams.Add("DayOffset", $DayOffset) }
                        }

                        $UpdatedVersion = Update-Version @UpdateParams
                    }

                    # Restore $Line to original state, with comments, etc.
                    $Line = $OrLine

                    if ($UpdatedVersion)
                    {
                        $Line = $Line.Replace($Version, $UpdatedVersion)
                        Write-Verbose ("New version " + $UpdatedVersion.ToString() + " in line ""$Line""")

                        $null = $Versions.Add(@{"Version" = $UpdatedVersion; "Line" = $Line})
                    }
                    else
                    {
                        Write-Verbose ("Found version " + $Version.ToString() + " in line ""$Line""")

                        $null = $Versions.Add(@{"Version" = $Version; "Line" = $Line})
                    }
                }
                else
                {
                    # $Line  contains $VersionKeyword but does not contain a version
                    $Line = $OrLine
                }
            }
            else
            {
                # Line contains $VersionKeyword but is a comment
                $Line = $OrLine
            }

            if ($IgnoredBefore -or $IgnoredMiddle -or $IgnoredAfter)
            {
                $IgnoredLine = $IgnoredBefore
                if ($IgnoredBefore -and ($IgnoredMiddle -or $IgnoredAfter)) {$IgnoredLine += "; "}
                $IgnoredLine += $IgnoredMiddle
                if (($IgnoredBefore -or $IgnoredMiddle) -and $IgnoredAfter) {$IgnoredLine += "; "}
                $IgnoredLine += $IgnoredAfter
                Write-Verbose "Ignoring $IgnoredLine"
            }
        }

        if ($Increment -or $Date)
        {
            if ($WhatIf) { Write-Host $Line }
            else { $Line | Out-File -FilePath $FilePath -Append }
        }
    }

    return $Versions


    <#
    .SYNOPSIS
        Finds or updates version in text file.

    .DESCRIPTION
        Parses input text file and extracts all Versions found in lines that contain -VersionKeyword.
        If -Increment or -Date is used, version will be updated in file accordingly.

    .PARAMETER FilePath
        Complete path of file to scan.

    .PARAMETER VersionKeyword,
        Word to search, e.g: Version.

    .PARAMETER Language
        Language of the file, used to properly handle comments.

    .PARAMETER Increment
        Value to increment.

    .PARAMETER Date
        Generate a new version number for Build or Revision, or both.
        If -Date is Build, the number will be written in Build part.
        If -Date is Revision, the number will be written in Revision part.
        If -Date is BuildAndRevision, Build will contain "day" part and
        Revision will contain "second" part.

    .PARAMETER DayOffset,
        A positive or negative number to add to the "day" part of the date algorithm.

    .OUTPUTS
        Array of hashtables, one for each line containing a version, composed of:
        - [Version] = a version object found in line
        - [Line] = the complete line

    .NOTES
        If Increment or Date is used, file will be updated, not piped to output.
    #>
}


function Find-Version
{
    param (
        [Parameter(Mandatory, ParameterSetName="FindLine")]
        [Parameter(Mandatory, ParameterSetName="IncrementLine")]
        [Parameter(Mandatory, ParameterSetName="DateLine")]
        [string]
        $Line,

        [Parameter(Mandatory, ParameterSetName="FindFile")]
        [Parameter(Mandatory, ParameterSetName="IncrementFile")]
        [Parameter(Mandatory, ParameterSetName="DateFile")]
        [string]
        $FilePath,

        [Parameter(ParameterSetName="FindFile")]
        [Parameter(ParameterSetName="IncrementFile")]
        [Parameter(ParameterSetName="DateFile")]
        [string]
        $VersionKeyword,

        [Parameter(ParameterSetName="FindFile")]
        [Parameter(ParameterSetName="IncrementFile")]
        [Parameter(ParameterSetName="DateFile")]
        [ValidateSet("cs", "xml", "js", "ps", "vb", "bat")]
        [string]
        $Language,

        [Parameter(Mandatory, ParameterSetName="IncrementLine")]
        [Parameter(Mandatory, ParameterSetName="IncrementFile")]
        [ValidateSet("Major", "Minor", "Build", "Revision")]
        [string]
        $Increment,

        [Parameter(Mandatory, ParameterSetName="DateLine")]
        [Parameter(Mandatory, ParameterSetName="DateFile")]
        [ValidateSet("BuildAndRevision", "Build", "Revision")]
        [string]
        # $Generate
        $Date,

        [Parameter(ParameterSetName="DateLine")]
        [Parameter(ParameterSetName="DateFile")]
        [int]
        $DayOffset,

        [Parameter(ParameterSetName="IncrementFile")]
        [Parameter(ParameterSetName="DateFile")]
        [Alias("DryRun")]
        [switch]
        $WhatIf
    )

    $UpdateArgs = @{}
    $FileArgs = @{}

    if ($Increment) { $UpdateArgs.Add("Increment", $Increment) }
    if ($Date)
    {
        $UpdateArgs.Add("Date", $Date)
        if ($DayOffset) { $UpdateArgs.Add("DayOffset", $DayOffset) }
    }

    if ($FilePath)
    {
        $FileArgs.Add("FilePath", $FilePath)
        if ($Language) { $FileArgs.Add("Language", $Language) }
        if ($VersionKeyword) { $FileArgs.Add("VersionKeyword", $VersionKeyword) }
    }

    if ($Line)
    {
        $Start, $Version, $End = Find-VersionInLine -Line $Line

        if ($Increment -or $Date)
        {
            $UpdatedVersion = Update-Version -Version $Version @UpdateArgs
            return $UpdatedVersion, $Line.Replace($Version, $UpdatedVersion)
        }
        else
        {
            return $Version, $Line
        }
    }
    if ($FilePath)
    {
        if ($Increment -or $Date)
        {
            $FileArgs.Add("WhatIf", $WhatIf)
            $Versions = Find-VersionInFile @FileArgs @UpdateArgs
            return ( $Versions | ForEach-Object { write-host ("New {0}: {1}" -f $VersionKeyword, $_.Version) } )
        }
        else
        {
            return Find-VersionInFile @FileArgs
        }
    }


    <#
    .SYNOPSIS
        Finds and updates version in text line or text file.

    .DESCRIPTION
        If -Line is passed:
            Parses input line of text and extracts the version part.
            Version contained in Line must follow Major.Minor[.Build[.Revision]] pattern, e.g.:
            1.2.3.4 or 1.2.3 or 1.2.
        If -FilePath is passed:
            Parses input text file and extracts all Versions found in lines that contain -VersionKeyword.
        If -Increment or -Date is used, version will be updated accordingly.

   .PARAMETER Line
        Line to scan.

    .PARAMETER FilePath
        Complete path of file to scan.

    .PARAMETER VersionKeyword
        Word to search, e.g: Version.

    .PARAMETER Language
        Language of the file, used to properly handle comments.

    .PARAMETER Increment
        Value to increment.

    .PARAMETER Date
        Generate a new version number for Build or Revision, or both.
        If -Date is Build, the number will be written in Build part.
        If -Date is Revision, the number will be written in Revision part.
        If -Date is BuildAndRevision, Build will contain "day" part and
        Revision will contain "second" part.

    .PARAMETER DayOffset,
        A positive or negative number to add to the "day" part of the date algorithm.

    .PARAMETER WhatIf
        Do not actually write file, only display what would happen.
    #>
}
