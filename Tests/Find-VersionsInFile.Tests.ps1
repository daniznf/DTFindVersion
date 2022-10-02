Describe "Find-VersionsInFile in AssemblyInfo-Test.cs" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psd1

        $FilePath = "$PSScriptRoot\AssemblyInfo-Test.cs"
        $VersionKeyword = "AssemblyVersion"
        $Language = "cs"
        $Versions = Find-VersionsInFile -FilePath $FilePath -VersionKeyword $VersionKeyword -Language $Language

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

        It "Returns 1.1.2.2" {
            $Versions[1].Version.Major | Should Be 1
            $Versions[1].Version.Minor | Should Be 1
            $Versions[1].Version.Build | Should Be 2
            $Versions[1].Version.Revision | Should Be 2
            $Versions[1].Line | Should Be "[assembly: AssemblyVersion(""1.1.2.2"")] // (""9.9.9.9"")]"
        }
    }

    AfterAll {
        Remove-Module DTFindVersion
    }
}

Describe "Find-VersionsInFile in Net60-Test.csproj" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psd1

        $FilePath = "$PSScriptRoot\Net60-Test.csproj"
        $VersionKeyword = "AssemblyVersion"
        $Language = "xml"
        $Versions = Find-VersionsInFile -FilePath $FilePath -VersionKeyword $VersionKeyword -Language $Language
    }

    Context "Versions in Net60-Test.csproj" {
        It "Has Length 5" {
            $Versions.Length | Should Be 4
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

        It "Returns 1.4.2" {
            $Versions[3].Version.Major | Should Be 1
            $Versions[3].Version.Minor | Should Be 4
            $Versions[3].Version.Build | Should Be 2
            $Versions[3].Version.Revision | Should Be -1
            $Versions[3].Line | Should Be "	1.4.2</AssemblyVersion>"
        }
    }

    AfterAll {
        Remove-Module DTFindVersion
    }
}

Describe "Find-VersionsInFile in Version-Test.xml" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psd1
        $FilePath = "$PSScriptRoot\Version-Test.xml"
        $VersionKeyword = "<Version>"
        $Language = "xml"

        $Versions = Find-VersionsInFile -FilePath $FilePath -VersionKeyword $VersionKeyword -Language $Language
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

Describe "Find-VersionsInFile in Version-Test.ps1" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psd1

        $FilePath = "$PSScriptRoot\Version-Test.ps1"
        $VersionKeyword = "Version"
        $Language = "ps"
        $Versions = Find-VersionsInFile -FilePath $FilePath -VersionKeyword $VersionKeyword -Language $Language
    }

    Context "Versions in Version-Test.ps1" {
        It "Has Length 9" {
            $Versions.Length | Should Be 9
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

    AfterAll {
        Remove-Module DTFindVersion
    }
}
