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

function Find-Version {
    param (
        [Parameter(Mandatory)]
        [string]
        $Line
    )

    $Found = $Line -match "(?<Start>\D*)(?<Major>\d+)\.?(?<Minor>\d+)?\.?(?<Build>\d+)?\.?(?<Revision>\d+)?(?<End>\D*)"

    if ($Found) { return $Matches }
    else { return $null }
}

Export-ModuleMember -Function Find-Version


<#
.SYNOPSIS
    Finds version in passed Line.

.DESCRIPTION
    Parses input line of text and extracts the version part.
    Version contained in passed line must be something like 1.2.3.4 or 1.2.3 or 1.2 or 1 or v1 or v1.2.3

    DTFindVersion v0.5.1

.PARAMETER Line
    Line to scan.

.OUTPUTS
    A hashtable with following keys:
    - Start = first part of the line, before version
    - Major = version's Major number
    - Minor = version's Minor number (if any)
    - Build = version's Build number (if any)
    - Revision = version's Revision number (if any)
    - End = last part of the line, after version
    - [0] = The complete line
#>
