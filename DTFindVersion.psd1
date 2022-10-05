# Module manifest for module 'DTFindVersion'

@{

# Script module or binary module file associated with this manifest.
RootModule = 'DTFindVersion.psm1'

# Version number of this module.
ModuleVersion = '0.22.1'

# ID used to uniquely identify this module
GUID = '9335a77e-bd13-4398-a393-cb1f614fe2b3'

# Author of this module
Author = 'daniznf'

# Company or vendor of this module
# CompanyName = 'znflabs'

# Copyright statement for this module
Copyright = '(c) 2022 daniznf. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Finds versions in line of text, or text files, corresponding to Major.Minor.Build.Revision pattern.'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @("Find-Version")

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = ''

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# List of all files packaged with this module
FileList = @("DTFindVersion.psd1", "DTFindVersion.psm1", "LICENSE", "README.md")

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{
    PSData = @{
        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @("Update", "Version", "Text", "File")

        # A URL to the license for this module.
        LicenseUri = 'https://www.gnu.org/licenses/gpl-3.0.txt'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/daniznf/DTFindVersion'

    } # End of PSData hashtable

} # End of PrivateData hashtable

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''
}

