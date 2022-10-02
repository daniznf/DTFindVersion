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
        Finds version in passed text Line.

    .DESCRIPTION
        Parses input line of text and extracts the version part.
        Version contained in passed line must be something like:
        1.2.3.4 or 1.2.3 or 1.2 or 1.2 or v1.2 or v1.2.3

    .PARAMETER Line
        Line to scan.

    .OUTPUTS
        An array composed of:
        - [0] = first part of the line, before version
        - [1] = a version object
        - [2] = last part of the line, after version
    #>
}

function Find-VersionsInFile
{
    param (
        [Parameter(Mandatory)]
        [string]
        $FilePath,
        [Parameter(Mandatory)]
        [string]
        $VersionKeyword,
        [ValidateSet("cs", "xml", "js", "ps", "vb", "bat")]
        [string]
        $Language
    )

    $Versions = [System.Collections.ArrayList]::new()

    if ( -not (Test-Path $FilePath))
    {
        Write-Host $FilePath
        throw [System.IO.FileNotFoundException]::new("Could not find $FilePath")
    }

    if (-not $Language)
    {
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
                Default { Write-Verbose "Could not guess file language!" }
            }
        }
        if ($Language) { Write-Verbose "File language has been automatically set to $Language."}
    }

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

        Default
        {
            $Comment, $CommentStart, $CommentEnd = $null
        }
    }

    if ($CommentStart) { $CutOffset = $CommentEnd.Length }
    else { $CutOffset = $null }

    $FileContent = Get-Content $FilePath

    for ($i = 0; $i -lt $FileContent.Length; $i++)
    {
        $Start, $Version, $End = $null
        $IgnoredBefore, $IgnoredMiddle, $IgnoredAfter = $null
        $Cut, $CutStart, $CutEnd = -1
        $OrLine = $FileContent[$i]
        $Line = $OrLine

        if ($OrLine.Contains($VersionKeyword))
        {
            if ($OrLine)
            {
                if ($CommentStart -and $CommentEnd)
                {
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
                    #               <# comment #> Version
                                    $Line = $OrLine.Substring($CutEnd + $CutOffset)
                                    $IgnoredBefore = $OrLine.Substring(0, $CutEnd + $CutOffset)
                                }
                                elseif ($OrLine.Trim().IndexOf($CommentEnd) -eq ($OrLine.Trim().Length - $CutOffset))
                                {
                    #               Version <# comment #>
                                    $Line = $OrLine.Substring(0, $CutStart)
                                    $IgnoredAfter = $OrLine.Substring($CutStart)
                                }
                                else
                                {
                    #               Version <# comment #> Version
                                    $Line = $OrLine.Substring(0, $CutStart)
                                    $IgnoredMiddle = $OrLine.Substring($CutStart, ($CutEnd + $CutOffset - $CutStart))
                                    $Line += $OrLine.Substring($CutEnd + $CutOffset)
                                }
                            }
                            else
                            {
                    #           comment#> Version <# comment
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

                if ($Line)
                {
                    $Start, $Version, $End = Find-VersionInLine -Line $Line
                    if ($Version)
                    {
                        Write-Verbose ("Found version " + $Version.ToString() + " in line ""$Line""")
                        $Line = $Start + $Version.ToString() + $End
                        $Line = $IgnoredBefore + $Line + $IgnoredAfter

                        if ($IgnoredMiddle -and ($CutStart -gt -1) -and ($CutStart -gt -1))
                        {
                            $Line = $Line.Substring(0, $CutStart) +
                                    $IgnoredMiddle +
                                    $Line.Substring($CutStart)
                        }

                        $Discard = $Versions.Add(@{"Version" = $Version; "Line" = $Line})
                }
            }

            if ($IgnoredBefore -or $IgnoredMiddle -or $IgnoredAfter)
                { Write-Verbose "Ignoring $IgnoredBefore; $IgnoredMiddle; $IgnoredAfter" }
        }
    }
}

    return $Versions

    <#
    .SYNOPSIS
        Finds version in passed text file.

    .DESCRIPTION
        Parses input text file and extracts all Versions found in lines that contain the passed VersionKeyword.

    .PARAMETER FilePath
        Complete path of file to scan

    .PARAMETER VersionKeyword,
        Word to search, e.g: Version

    .PARAMETER Language
        Language of the file, used to properly handle comments

    .OUTPUTS
        Array of hashtables containing the Version object found in lines and the complete line
    #>
}
