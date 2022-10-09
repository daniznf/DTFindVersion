param (
    [string]
    $ModulesDir
)

$ModuleName = Split-Path $PSScriptRoot -Leaf

Write-Host "This installation script is going to install $ModuleName."
Write-Host ""

if (-not $ModulesDir)
{
    $ModulePaths = $env:PSModulePath.Split(";")

    if ($ModulePaths -is [System.Array])
    {
        Write-host "Recognized module paths are:"
        for ($i = 0; $i -lt $ModulePaths.Length; $i++)
        {
            Write-Host ("{0}: {1}" -f $i, $ModulePaths[$i])
        }

        Write-Host ""
        [uint16] $Choice = Read-Host -Prompt ("Please choose where you want to install module [{0}-{1}]" -f 0, ($ModulePaths.Length-1) )

        $ModulesDir = $ModulePaths[$Choice]
        Write-Host ""
    }
    else # $ModulesPaths is string
    {
        $ModulesDir = $ModulesPaths
    }
}

$ModuleDir = Join-Path $ModulesDir $ModuleName

Write-Host "Module directory will be: $ModuleDir."
Write-Host ""

[string] $Choice = Read-Host -Prompt ("Continue? [y-n]")
if (($Choice -ne "y") -and ($Choice -ne "yes"))
{
    Write-Host "Installation aborted."
    exit 1
}

if (-not (Test-Path $ModuleDir))
{
    Write-Host "Creating $ModuleDir ..."
    New-Item -Path $ModuleDir -ItemType Directory -ErrorAction Stop
    Write-Host ""
}

if (Test-Path $ModuleDir)
{
    Remove-Module $ModuleName -ErrorAction Ignore

    Write-Host "Copying module files..."
    Copy-Item -Path .\* -Destination $ModuleDir -Include "*.psd1","*.psm1", "README.md", "LICENSE" -ErrorAction Stop

    Write-Host ""
    Write-Host "Installation finished!"
}
else
{
    throw "Could not create $ModuleDir"
}
