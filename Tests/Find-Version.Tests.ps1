Describe "Find-Version in AssemblyInfo-Test.cs" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psd1
        $FilePath = "$PSScriptRoot\AssemblyInfo-Test.cs"
        $Versionkeywords = "AssemblyVersion"
        $Language = "cs"
    }

    Context "Find-Version in AssemblyInfo-Test.cs" {
        BeforeAll {
            $Versions = Find-Version -FilePath $FilePath -Versionkeywords $Versionkeywords -Language $Language
        }

        It "Returns 1.1.1.1" {
            $Versions[0].Version.Major | Should Be 1
            $Versions[0].Version.Minor | Should Be 1
            $Versions[0].Version.Build | Should Be 1
            $Versions[0].Version.Revision | Should Be 1
            $Versions[0].Line | Should Be "[assembly: AssemblyVersion(""1.1.1.1"")]"
        }

        It "Returns 1.1.4.2" {
            $Versions[1].Version.Major | Should Be 1
            $Versions[1].Version.Minor | Should Be 1
            $Versions[1].Version.Build | Should Be 4
            $Versions[1].Version.Revision | Should Be 1
            $Versions[1].Line | Should Be "[assembly: AssemblyVersion(""1.1.4.1"")] // (""1.1.4.2"")]"
        }
    }

    Context "Find-Version in AssemblyInfo-Test without Language" {
        BeforeAll {
            Import-Module $PSScriptRoot\..\DTFindVersion.psd1
            $Versions = Find-Version -FilePath $FilePath -Versionkeywords $Versionkeywords
        }

        It "Returns 1.1.1.1" {
            $Versions[0].Version.Major | Should Be 1
            $Versions[0].Version.Minor | Should Be 1
            $Versions[0].Version.Build | Should Be 1
            $Versions[0].Version.Revision | Should Be 1
            $Versions[0].Line | Should Be "[assembly: AssemblyVersion(""1.1.1.1"")]"
        }

        It "Returns 1.1.4.2" {
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

Describe "Find-Version in Net60-Test.csproj" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psd1

        $FilePath = "$PSScriptRoot\Net60-Test.csproj"
        $Versionkeywords = "AssemblyVersion"
        $Language = "xml"
    }

    Context "Versions in Net60-Test.csproj" {
        BeforeAll {
            Import-Module $PSScriptRoot\..\DTFindVersion.psd1
            $Versions = Find-Version -FilePath $FilePath -Versionkeywords $Versionkeywords -Language $Language
        }

        It "Returns 1.1.1" {
            $Versions[0].Version.Major | Should Be 1
            $Versions[0].Version.Minor | Should Be 1
            $Versions[0].Version.Build | Should Be 1
            $Versions[0].Version.Revision | Should Be -1
            $Versions[0].Line | Should Be "	<AssemblyVersion>1.1.1<!-- comment"
        }

        It "Returns 1.5.1" {
            $Versions[4].Version.Major | Should Be 1
            $Versions[4].Version.Minor | Should Be 5
            $Versions[4].Version.Build | Should Be 1
            $Versions[4].Version.Revision | Should Be -1
            $Versions[4].Line | Should Be "	<AssemblyVersion>1.5.1</AssemblyVersion>"
        }
    }

    Context "Versions in Net60-Test.csproj without Versionkeywords" {
        BeforeAll {
            Import-Module $PSScriptRoot\..\DTFindVersion.psd1
            $Versions = Find-Version -FilePath $FilePath -Language $Language
        }

        It "Returns 6.0" {
            $Versions[0].Version.Major | Should Be 6
            $Versions[0].Version.Minor | Should Be 0
            $Versions[0].Version.Build | Should Be -1
            $Versions[0].Version.Revision | Should Be -1
            $Versions[0].Line | Should Be "	<TargetFramework>net6.0</TargetFramework>"
        }

        It "Returns 1.5.1" {
            $Versions[5].Version.Major | Should Be 1
            $Versions[5].Version.Minor | Should Be 5
            $Versions[5].Version.Build | Should Be 1
            $Versions[5].Version.Revision | Should Be -1
            $Versions[5].Line | Should Be "	<AssemblyVersion>1.5.1</AssemblyVersion>"
        }
    }

    Context "Versions in Net60-Test.csproj with multiple keywords" {
        BeforeAll {
            Import-Module $PSScriptRoot\..\DTFindVersion.psd1
            $Versionkeywords = "AssemblyVersion", "FileVersion"
            $Versions = Find-Version -FilePath $FilePath -Versionkeywords $Versionkeywords -Language $Language
        }

        It "Returns 1.1.1" {
            $Versions[0].Version.Major | Should Be 1
            $Versions[0].Version.Minor | Should Be 1
            $Versions[0].Version.Build | Should Be 1
            $Versions[0].Version.Revision | Should Be -1
            $Versions[0].Line | Should Be "	<AssemblyVersion>1.1.1<!-- comment"
        }

        It "Returns 1.5.1" {
            $Versions[4].Version.Major | Should Be 1
            $Versions[4].Version.Minor | Should Be 5
            $Versions[4].Version.Build | Should Be 1
            $Versions[4].Version.Revision | Should Be -1
            $Versions[4].Line | Should Be "	<AssemblyVersion>1.5.1</AssemblyVersion>"
        }

        It "Returns 1.7.1" {
            $Versions[5].Version.Major | Should Be 1
            $Versions[5].Version.Minor | Should Be 7
            $Versions[5].Version.Build | Should Be 1
            $Versions[5].Version.Revision | Should Be -1
            $Versions[5].Line | Should Be "	<FileVersion>1.7.1</FileVersion>"
        }
    }

    AfterAll {
        Remove-Module DTFindVersion
    }
}
