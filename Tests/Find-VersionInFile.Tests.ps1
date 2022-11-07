Describe "Find-VersionInFile in AssemblyInfo-Test.cs" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psm1

        $FilePath = "$PSScriptRoot\AssemblyInfo-Test.cs"
        $Versionkeywords = "AssemblyVersion"
        $Language = "cs"
        $Versions = Find-VersionInFile -FilePath $FilePath -Versionkeywords $Versionkeywords -Language $Language
    }

    Context "Versions in AssemblyInfo-Test.cs" {
        It "Has Length 2" {
            $Versions.Length | Should Be 2
        }

        It "Returns 1.1.1.1" {
            $Versions[0].Version.Major | Should Be 1
            $Versions[0].Version.Minor | Should Be 1
            $Versions[0].Version.Build | Should Be 1
            $Versions[0].Version.Revision | Should Be 1
            $Versions[0].Line | Should Be "[assembly: AssemblyVersion(""1.1.1.1"")]"
        }

        It "Returns 1.1.4.1" {
            $Versions[1].Version.Major | Should Be 1
            $Versions[1].Version.Minor | Should Be 1
            $Versions[1].Version.Build | Should Be 4
            $Versions[1].Version.Revision | Should Be 1
            $Versions[1].Line | Should Be "[assembly: AssemblyVersion(""1.1.4.1"")] // (""1.1.4.2"")]"
        }
    }

    AfterAll {
        Remove-Module DTFindVersion
    }
}

Describe "Find-VersionInFile in Net60-Test.csproj" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psm1

        $FilePath = "$PSScriptRoot\Net60-Test.csproj"
        $Versionkeywords = "AssemblyVersion"
        $Language = "xml"
        $Versions = Find-VersionInFile -FilePath $FilePath -Versionkeywords $Versionkeywords -Language $Language
    }

    Context "Versions in Net60-Test.csproj" {
        It "Has Length 5" {
            $Versions.Length | Should Be 6
            Write-Host "It should be 5 when multi line will be correctly handled"
        }

        It "Returns 1.1.1" {
            $Versions[0].Version.Major | Should Be 1
            $Versions[0].Version.Minor | Should Be 1
            $Versions[0].Version.Build | Should Be 1
            $Versions[0].Version.Revision | Should Be -1
            $Versions[0].Line | Should Be "	<AssemblyVersion>1.1.1<!-- comment"
        }

        It "Returns 1.2.1" {
            $Versions[1].Version.Major | Should Be 1
            $Versions[1].Version.Minor | Should Be 2
            $Versions[1].Version.Build | Should Be 1
            $Versions[1].Version.Revision | Should Be -1
            $Versions[1].Line | Should Be "	<AssemblyVersion><!--comment-->1.2.1</AssemblyVersion>"
        }

        It "Returns 1.3.1" {
            $Versions[2].Version.Major | Should Be 1
            $Versions[2].Version.Minor | Should Be 3
            $Versions[2].Version.Build | Should Be 1
            $Versions[2].Version.Revision | Should Be -1
            $Versions[2].Line | Should Be "	<AssemblyVersion>1.3.1<!--comment--></AssemblyVersion>"

        }

        It "Returns 1.4.1" {
            $Versions[3].Version.Major | Should Be 1
            $Versions[3].Version.Minor | Should Be 4
            $Versions[3].Version.Build | Should Be 1
            $Versions[3].Version.Revision | Should Be -1
            $Versions[3].Line | Should Be "	1.4.1</AssemblyVersion>"
        }

        It "Returns 1.5.1" {
            $Versions[4].Version.Major | Should Be 1
            $Versions[4].Version.Minor | Should Be 5
            $Versions[4].Version.Build | Should Be 1
            $Versions[4].Version.Revision | Should Be -1
            $Versions[4].Line | Should Be "	<AssemblyVersion>1.5.1</AssemblyVersion>"
        }
    }

    AfterAll {
        Remove-Module DTFindVersion
    }
}

Describe "Find-VersionInFile in Version-Test.xml" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psm1

        $FilePath = "$PSScriptRoot\Version-Test.xml"
        $Versionkeywords = "<Version>"
        $Language = "xml"
        $Versions = Find-VersionInFile -FilePath $FilePath -Versionkeywords $Versionkeywords -Language $Language
    }

    Context "Versions in Version-Test.xml" {
        It "Has Length 1" {
            $Versions.Length | Should Be 1
        }

        It "Returns 1.2.3" {
            $Versions.Version.Major | Should Be 1
            $Versions.Version.Minor | Should Be 2
            $Versions.Version.Build | Should Be 3
            $Versions.Version.Revision | Should Be -1
            $Versions.Line | Should Be "    <Version>1.2.3</Version>"
        }
    }

    AfterAll {
        Remove-Module DTFindVersion
    }
}


Describe "Find-VersionInFile in Version-Test.ps1" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psm1

        $FilePath = "$PSScriptRoot\Version-Test.ps1"
    }

    Context "Versions in Version-Test.ps1" {
        BeforeAll {
            $Versionkeywords = "Version"
            $Language = "ps"
            $Versions = Find-VersionInFile -FilePath $FilePath -Versionkeywords $Versionkeywords -Language $Language
        }

        It "Has Length 9" {
            $Versions.Length | Should Be 11
            Write-Host "It should be 9 when multi line will be correctly handled"
        }

        It "Returns 1.2.1" {
            $Versions[0].Version.Major | Should Be 1
            $Versions[0].Version.Minor | Should Be 2
            $Versions[0].Version.Build | Should Be 1
            $Versions[0].Version.Revision | Should Be -1
            $Versions[0].Line | Should Be ("$"+"Version = ""1.2.1"" # Version = ""1.2.2""")
        }

        It "Returns 1.3.1" {
            $Versions[1].Version.Major | Should Be 1
            $Versions[1].Version.Minor | Should Be 3
            $Versions[1].Version.Build | Should Be 1
            $Versions[1].Version.Revision | Should Be -1
            $Versions[1].Line | Should Be ("$"+"Version = ""1.3.1""")
        }

        It "Returns 1.4.1" {
            $Versions[2].Version.Major | Should Be 1
            $Versions[2].Version.Minor | Should Be 4
            $Versions[2].Version.Build | Should Be 1
            $Versions[2].Version.Revision | Should Be -1
            $Versions[2].Line | Should Be ("$"+"Version = ""1.4.1"" <# $"+"Version = ""1.4.2"" #>")
        }

        It "Returns 1.5.2" {
            $Versions[3].Version.Major | Should Be 1
            $Versions[3].Version.Minor | Should Be 5
            $Versions[3].Version.Build | Should Be 2
            $Versions[3].Version.Revision | Should Be -1
            $Versions[3].Line | Should Be ("<# $"+"Version = ""1.5.1"" #> $"+"Version = ""1.5.2""")
        }

        It "Returns 1.6.2" {
            $Versions[4].Version.Major | Should Be 1
            $Versions[4].Version.Minor | Should Be 6
            $Versions[4].Version.Build | Should Be 2
            $Versions[4].Version.Revision | Should Be -1
            $Versions[4].Line | Should Be ("$"+"Version <# middle comment = ""1.6.1"" #>  = ""1.6.2""")
        }

        It "Returns 1.7.1" {
            $Versions[5].Version.Major | Should Be 1
            $Versions[5].Version.Minor | Should Be 7
            $Versions[5].Version.Build | Should Be 1
            $Versions[5].Version.Revision | Should Be -1
            $Versions[5].Line | Should Be ("$"+"Version = ""1.7.1"" <# $"+"Version = ""1.7.2""")
        }

        It "Returns 1.8.2" {
            $Versions[6].Version.Major | Should Be 1
            $Versions[6].Version.Minor | Should Be 8
            $Versions[6].Version.Build | Should Be 2
            $Versions[6].Version.Revision | Should Be -1
            $Versions[6].Line | Should Be ("$"+"Version = ""1.8.1"" #> $"+"Version = ""1.8.2""")
        }

        It "Returns 1.9.2" {
            $Versions[7].Version.Major | Should Be 1
            $Versions[7].Version.Minor | Should Be 9
            $Versions[7].Version.Build | Should Be 2
            $Versions[7].Version.Revision | Should Be -1
            $Versions[7].Line | Should Be ("$"+"Version = ""1.9.1"" #> $"+"Version = ""1.9.2"" <# comment")
        }

        It "Returns 1.10.2" {
            $Versions[8].Version.Major | Should Be 1
            $Versions[8].Version.Minor | Should Be 10
            $Versions[8].Version.Build | Should Be 2
            $Versions[8].Version.Revision | Should Be -1
            $Versions[8].Line | Should Be ("$"+"Version = ""1.10.1"" #> $"+"Version = ""1.10.2""")
        }
    }

    Context "Versions Without Versionkeywords" {
        BeforeAll {
            $Language = "ps"
            $Versions = Find-VersionInFile -FilePath $FilePath -Language $Language
        }

        It "Has Length 11" {
            $Versions.Length | Should Be 15
            Write-Host "It should be 11 when multi line will be correctly handled"
        }

        It "Returns 2.1.1" {
            $Versions[9].Version.Major | Should Be 2
            $Versions[9].Version.Minor | Should Be 1
            $Versions[9].Version.Build | Should Be 1
            $Versions[9].Version.Revision | Should Be -1
            $Versions[9].Line | Should Be ("$"+"AnotherVersion = ""2.1.1""")
        }

        It "Returns 2.2.1" {
            $Versions[10].Version.Major | Should Be 2
            $Versions[10].Version.Minor | Should Be 2
            $Versions[10].Version.Build | Should Be 1
            $Versions[10].Version.Revision | Should Be -1
            $Versions[10].Line | Should Be ("$"+"AnotherNumber = ""2.2.1""")
        }
    }

    Context "Versions Without Language" {
        BeforeAll {
            $Versionkeywords = "Version"
            $Versions = Find-VersionInFile -FilePath $FilePath -Versionkeywords $Versionkeywords
        }

        It "Has Length 10" {
            $Versions.Length | Should Be 11
            Write-Host "It should be 10 when multi line will be correctly handled"
        }
    }

    Context "Versions Without Language nor Versionkeywords" {
        BeforeAll {
            $Versions = Find-VersionInFile -FilePath $FilePath
        }

        It "Has Length 11" {
            $Versions.Length | Should Be 15
            Write-Host "It should be 5 when multi line will be correctly handled"
        }
    }

    AfterAll {
        Remove-Module DTFindVersion
    }
}


Describe "Update-Version in AssemblyInfo-Test.cs" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psm1

        $FilePath = "$PSScriptRoot\AssemblyInfo-Test.cs"
        $FilePathTesting = "$PSScriptRoot\AssemblyInfo-Test-Testing.cs"

        $Versionkeywords = "AssemblyVersion"
        $Language = "cs"
    }

    Context "Increment Revision in AssemblyInfo-Test.cs" {
        BeforeAll {
            Copy-Item -Path $FilePath -Destination $FilePathTesting

            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language -Increment Revision
            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language
        }

        It "Has Length 2" {
            $Versions.Length | Should Be 2
        }

        It "Returns 1.1.1.2" {
            $Versions[0].Version.Major | Should Be 1
            $Versions[0].Version.Minor | Should Be 1
            $Versions[0].Version.Build | Should Be 1
            $Versions[0].Version.Revision | Should Be 2
            $Versions[0].Line | Should Be "[assembly: AssemblyVersion(""1.1.1.2"")]"
        }

        It "Returns 1.1.4.2" {
            $Versions[1].Version.Major | Should Be 1
            $Versions[1].Version.Minor | Should Be 1
            $Versions[1].Version.Build | Should Be 4
            $Versions[1].Version.Revision | Should Be 2
            $Versions[1].Line | Should Be "[assembly: AssemblyVersion(""1.1.4.2"")] // (""1.1.4.2"")]"
        }

        AfterAll {
            Remove-Item -Path $FilePathTesting
            Remove-Item -Path ($FilePathTesting + ".bak")
        }
    }

    Context "Generate Revision in AssemblyInfo-Test.cs" {
        BeforeAll {
            Copy-Item -Path $FilePath -Destination $FilePathTesting

            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language -Generate Revision
            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language
        }

        It "Has Length 2" {
            $Versions.Length | Should Be 2
        }

        It "Returns 1.1.1.x" {
            $Versions[0].Version.Major | Should Be 1
            $Versions[0].Version.Minor | Should Be 1
            $Versions[0].Version.Build | Should Be 1
            $Versions[0].Version.Revision | Should BeGreaterThan 0
            $Versions[0].Line.Contains("[assembly: AssemblyVersion(""1.1.1.") | Should Be $true
        }

        It "Returns 1.1.4.x" {
            $Versions[1].Version.Major | Should Be 1
            $Versions[1].Version.Minor | Should Be 1
            $Versions[1].Version.Build | Should Be 4
            $Versions[1].Version.Revision | Should BeGreaterThan 0
            $Versions[1].Line.Contains("[assembly: AssemblyVersion(""1.1.4.") | Should Be $true
        }

        AfterAll {
            Remove-Item -Path $FilePathTesting
            Remove-Item -Path ($FilePathTesting + ".bak")
        }
    }

    Context "Generate Build and Revision in AssemblyInfo-Test.cs" {
        BeforeAll {
            Copy-Item -Path $FilePath -Destination $FilePathTesting

            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language -Generate BuildAndRevision
            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language
        }

        It "Has Length 2" {
            $Versions.Length | Should Be 2
        }

        It "Returns 1.1.x.x" {
            $Versions[0].Version.Major | Should Be 1
            $Versions[0].Version.Minor | Should Be 1
            $Versions[0].Version.Build | Should BeGreaterThan 0
            $Versions[0].Version.Revision | Should BeGreaterThan 0
            $Versions[0].Line | Should Match "[assembly: AssemblyVersion(""1.1."")]"
        }

        It "Returns 1.1.x.x" {
            $Versions[1].Version.Major | Should Be 1
            $Versions[1].Version.Minor | Should Be 1
            $Versions[1].Version.Build | Should BeGreaterThan 0
            $Versions[1].Version.Revision | Should BeGreaterThan 0
            $Versions[1].Line.Contains("[assembly: AssemblyVersion(""1.1.") | Should Be $true
        }

        AfterAll {
            Remove-Item -Path $FilePathTesting
            Remove-Item -Path ($FilePathTesting + ".bak")
        }
    }

    AfterAll {
        Remove-Module DTFindVersion
    }
}

Describe "Update-Version in Net60-Test.csproj" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psm1

        $FilePath = "$PSScriptRoot\Net60-Test.csproj"
        $FilePathTesting = "$PSScriptRoot\Net60-Test-Testing.csproj"
        Copy-Item -Path $FilePath -Destination $FilePathTesting

        $Versionkeywords = "AssemblyVersion"
        $Language = "xml"
        $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language -Increment Minor
        $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language
    }

    Context "Increment Minor in Net60-Test.csproj" {
        It "Has Length 5" {
            $Versions.Length | Should Be 6
            Write-Host "It should be 5 when multi line will be correctly handled"
        }

        It "Returns 1.2.1" {
            $Versions[0].Version.Major | Should Be 1
            $Versions[0].Version.Minor | Should Be 2
            $Versions[0].Version.Build | Should Be 1
            $Versions[0].Version.Revision | Should Be -1
            $Versions[0].Line | Should Be "	<AssemblyVersion>1.2.1<!-- comment"
        }

        It "Returns 1.3.1" {
            $Versions[1].Version.Major | Should Be 1
            $Versions[1].Version.Minor | Should Be 3
            $Versions[1].Version.Build | Should Be 1
            $Versions[1].Version.Revision | Should Be -1
            $Versions[1].Line | Should Be "	<AssemblyVersion><!--comment-->1.3.1</AssemblyVersion>"
        }

        AfterAll {
            Remove-Item -Path $FilePathTesting
            Remove-Item -Path ($FilePathTesting + ".bak")
            Remove-Module DTFindVersion
        }
    }
}

Describe "Update-Version in Version-Test.xml" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psm1

        $FilePath = "$PSScriptRoot\Version-Test.xml"
        $FilePathTesting = "$PSScriptRoot\Version-Test-Testing.xml"
        Copy-Item -Path $FilePath -Destination $FilePathTesting

        $Versionkeywords = "<Version>"
        $Language = "xml"
        $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language -Increment Build
        $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language
    }

    Context "Increment Build in Version-Test.xml" {
        It "Has Length 1" {
            $Versions.Length | Should Be 1
        }

        It "Returns 1.2.4" {
            $Versions.Version.Major | Should Be 1
            $Versions.Version.Minor | Should Be 2
            $Versions.Version.Build | Should Be 4
            $Versions.Version.Revision | Should Be -1
            $Versions.Line | Should Be "    <Version>1.2.4</Version>"
        }
    }

    AfterAll {
        Remove-Item -Path $FilePathTesting
        Remove-Item -Path ($FilePathTesting + ".bak")
        Remove-Module DTFindVersion
    }
}


Describe "Update-Version in Version-Test.ps1" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psm1

        $FilePath = "$PSScriptRoot\Version-Test.ps1"
        $FilePathTesting = "$PSScriptRoot\Version-Test-Testing.ps1"
    }

    Context "Increment Major in Version-Test.ps1" {
        BeforeAll {
            Copy-Item -Path $FilePath -Destination $FilePathTesting

            $Versionkeywords = "Version"
            $Language = "ps"
            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language -Increment Major
            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language
        }

        It "Has Length 9" {
            $Versions.Length | Should Be 11
            Write-Host "It should be 9 when multi line will be correctly handled"
        }

        It "Returns 2.2.1" {
            $Versions[0].Version.Major | Should Be 2
            $Versions[0].Version.Minor | Should Be 2
            $Versions[0].Version.Build | Should Be 1
            $Versions[0].Version.Revision | Should Be -1
            $Versions[0].Line | Should Be ("$"+"Version = ""2.2.1"" # Version = ""1.2.2""")
        }

        It "Returns 2.3.1" {
            $Versions[1].Version.Major | Should Be 2
            $Versions[1].Version.Minor | Should Be 3
            $Versions[1].Version.Build | Should Be 1
            $Versions[1].Version.Revision | Should Be -1
            $Versions[1].Line | Should Be ("$"+"Version = ""2.3.1""")
        }

        AfterAll {
            Remove-Item -Path $FilePathTesting
            Remove-Item -Path ($FilePathTesting + ".bak")
        }
    }

    Context "Generate Build in Version-Test.ps1" {
        BeforeAll {
            Copy-Item -Path $FilePath -Destination $FilePathTesting

            $Language = "ps"
            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Language $Language -Generate Build
            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Language $Language
        }

        It "Has Length 11" {
            $Versions.Length | Should Be 15
            Write-Host "It should be 11 when multi line will be correctly handled"
        }

        It "Returns 1.1.x" {
            $Versions[9].Version.Major | Should Be 2
            $Versions[9].Version.Minor | Should Be 1
            $Versions[9].Version.Build | Should BeGreaterThan 0
            $Versions[9].Version.Revision | Should Be -1
            $Versions[9].Line.Contains("$"+"AnotherVersion = ""2.1.") | Should Be $true
        }

        It "Returns 2.2.x" {
            $Versions[10].Version.Major | Should Be 2
            $Versions[10].Version.Minor | Should Be 2
            $Versions[10].Version.Build | Should BeGreaterThan 0
            $Versions[10].Version.Revision | Should Be -1
            $Versions[10].Line.Contains("$"+"AnotherNumber = ""2.2.") | Should Be $true
        }

        AfterAll {
            Remove-Item -Path $FilePathTesting
            Remove-Item -Path ($FilePathTesting + ".bak")
        }
    }

    Context "Increment Major in Version-Test.ps1 with multiple keywords" {
        BeforeAll {
            Copy-Item -Path $FilePath -Destination $FilePathTesting

            $Versionkeywords = "Version", "Also", "And"
            $Language = "ps"
            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language -Increment Major
            $Versions = Find-VersionInFile -FilePath $FilePathTesting -Versionkeywords $Versionkeywords -Language $Language
        }

        It "Has Length 12" {
            $Versions.Length | Should Be 13
            Write-Host "It should be 12 when multi line will be correctly handled"
        }

        It "Returns 4.1.1" {
            $Versions[10].Version.Major | Should Be 4
            $Versions[10].Version.Minor | Should Be 1
            $Versions[10].Version.Build | Should Be 1
            $Versions[10].Version.Revision | Should Be -1
            $Versions[10].Line | Should Be ("$"+"AlsoThis = ""4.1.1""")
        }

        It "Returns 4.2.1" {
            $Versions[11].Version.Major | Should Be 4
            $Versions[11].Version.Minor | Should Be 2
            $Versions[11].Version.Build | Should Be 1
            $Versions[11].Version.Revision | Should Be -1
            $Versions[11].Line | Should Be ("$"+"AndThis = ""4.2.1""")
        }

        AfterAll {
            Remove-Item -Path $FilePathTesting
            Remove-Item -Path ($FilePathTesting + ".bak")
        }
    }


    AfterAll {
        Remove-Module DTFindVersion
    }
}
