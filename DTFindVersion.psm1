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

function Find-VersionInLine {
    param (
        [Parameter(Mandatory)]
        [string]
        $Line
    )

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

function Find-VersionInFile
{
    param (
        [Parameter(Mandatory)]
        [string]
        $FilePath,
        [Parameter(Mandatory)]
        [string]
        $VersionTag
    )

    if ((-not $FilePath) -or ( -not (Test-Path $FilePath)))
    {
        Write-Host $FilePath
        throw [System.IO.FileNotFoundException]::new($FilePath)
    }

    $FileContent = Get-Content $FilePath

    for ($i = 0; $i -lt $FileContent.Length; $i++)
    {
        $Line = $FileContent[$i]
        if ($Line.Contains($VersionTag))
        {
            $Start, $Version, $End = Find-VersionInLine -Line $Line
            if ($Version)
            {
                Write-Verbose ("Found version " + $VersionString + " in line ""$Line""")
                return $Start, $Version, $End
            }
        }
    }

    <#
    .SYNOPSIS
        Finds version in passed text file.

    .DESCRIPTION
        Parses input text file and extracts the first Version found in lines that contain the passed VersionTag.

    .PARAMETER Line
        Line to scan.

    .OUTPUTS
        An array composed of:
        - [0] = first part of the line, before version
        - [1] = a Version object
        - [2] = last part of the line, after version
    #>
 }

Export-ModuleMember -Function Find-VersionInLine, Find-VersionInFile
