Describe "Find-Version" {
    BeforeAll {
         Import-Module $PSScriptRoot\..\DTFindVersion.psm1
    }

    Context "AssemblyVersion 4 numbers" {
        It "Returns 1.2.3.4" {
            $Start, $Version, $End = Find-Version -Line "[assembly: AssemblyVersion(""1.2.3.4"")]"
            $Start | Should Be "[assembly: AssemblyVersion("""
            $Version.Major | Should Be 1
            $Version.Minor | Should Be 2
            $Version.Build | Should Be 3
            $Version.Revision | Should Be 4
            $End | Should Be """)]"
            $Start + $Version[0] + $End | Should Be "[assembly: AssemblyVersion(""1.2.3.4"")]"
        }
    }

    Context "AssemblyVersion 3 numbers" {
        It "Returns 1.2.3" {
            $Start, $Version, $End = Find-Version -Line "[assembly: AssemblyVersion(""1.2.3"")]"
            $Start | Should Be "[assembly: AssemblyVersion("""
            $Version.Major | Should Be 1
            $Version.Minor | Should Be 2
            $Version.Build | Should Be 3
            $Version.Revision | Should Be -1
            $End | Should Be """)]"
        }
    }

    Context "AssemblyVersion 2 numbers" {
        It "Returns 1.2" {
            $Start, $Version, $End = Find-Version -Line "[assembly: AssemblyVersion(""1.2"")]"
            $Start | Should Be "[assembly: AssemblyVersion("""
            $Version.Major | Should Be 1
            $Version.Minor | Should Be 2
            $Version.Build | Should Be -1
            $Version.Revision | Should Be -1
            $End | Should Be """)]"
        }
    }

    Context "AssemblyVersion 1 number" {
        It "Returns null" {
            $Start, $Version, $End = Find-Version -Line "[assembly: AssemblyVersion(""1"")]"
            $Start | Should Be $null
            $Version | Should Be $null
            $End | Should Be $null
        }
    }

    Context "AssemblyVersion Minor Zero " {
        It "Returns 1.0.3" {
            $Start, $Version, $End = Find-Version -Line "[assembly: AssemblyVersion(""1.0.3"")]"
            $Start | Should Be "[assembly: AssemblyVersion("""
            $Version.Major | Should Be 1
            $Version.Minor | Should Be 0
            $Version.Build | Should Be 3
            $Version.Revision | Should Be -1
            $End | Should Be """)]"
        }
    }

    Context "AssemblyVersion Major Zero" {
        It "Returns 0.2.3" {
            $Start, $Version, $End = Find-Version -Line "[assembly: AssemblyVersion(""0.2.3"")]"
            $Start | Should Be "[assembly: AssemblyVersion("""
            $Version.Major | Should Be 0
            $Version.Minor | Should Be 2
            $Version.Build | Should Be 3
            $Version.Revision | Should Be -1
            $End | Should Be """)]"
        }
    }

    Context "AssemblyVersion Major and Minor Zero" {
        It "Returns 0.0.3" {
            $Start, $Version, $End = Find-Version -Line "[assembly: AssemblyVersion(""0.0.3"")]"
            $Start | Should Be "[assembly: AssemblyVersion("""
            $Version.Major | Should Be 0
            $Version.Minor | Should Be 0
            $Version.Build | Should Be 3
            $Version.Revision | Should Be -1
            $End | Should Be """)]"
        }
    }

    Context "AssemblyVersion Zero" {
        It "Returns 0.0.0" {
            $Start, $Version, $End = Find-Version -Line "[assembly: AssemblyVersion(""0.0.0"")]"
            $Start | Should Be "[assembly: AssemblyVersion("""
            $Version.Major | Should Be 0
            $Version.Minor | Should Be 0
            $Version.Build | Should Be 0
            $Version.Revision | Should Be -1
            $End | Should Be """)]"
        }
    }

    Context "xml 3 numbers" {
        It "Returns 1.2.3" {
            $Start, $Version, $End = Find-Version -Line "<FileVersion>1.2.3</FileVersion>"
            $Start | Should Be "<FileVersion>"
            $Version.Major | Should Be 1
            $Version.Minor | Should Be 2
            $Version.Build | Should Be 3
            $Version.Revision | Should Be -1
            $End | Should Be "</FileVersion>"
        }
    }

    Context "xml 3 numbers v" {
        It "Returns 1.2.3" {
            $Start, $Version, $End = Find-Version -Line "<Version>v1.2.3</Version>"
            $Start | Should Be "<Version>v"
            $Version.Major | Should Be 1
            $Version.Minor | Should Be 2
            $Version.Build | Should Be 3
            $Version.Revision | Should Be -1
            $End | Should Be "</Version>"
        }
    }

    Context "xml 4 numbers and zeroes" {
        It "Returns 0.0.3.0" {
            $Start, $Version, $End = Find-Version -Line "<FileVersion>0.0.3.0</FileVersion>"
            $Start | Should Be "<FileVersion>"
            $Version.Major | Should Be 0
            $Version.Minor | Should Be 0
            $Version.Build | Should Be 3
            $Version.Revision | Should Be 0
            $End | Should Be "</FileVersion>"
        }
    }

    Context "Multi digit numbers and zeroes" {
        It "Returns 0.0.13.5678" {
            $Start, $Version, $End = Find-Version -Line "<FileVersion>0.0.13.5678</FileVersion>"
            $Start | Should Be "<FileVersion>"
            $Version.Major | Should Be 0
            $Version.Minor | Should Be 0
            $Version.Build | Should Be 13
            $Version.Revision | Should Be 5678
            $End | Should Be "</FileVersion>"
        }
    }

    Context "Zero-padded" {
        It "Returns 0.01.03.100" {
            $Start, $Version, $End = Find-Version -Line "<FileVersion>0.01.03.100</FileVersion>"
            $Start | Should Be "<FileVersion>"
            $Version.Major | Should Be 0
            $Version.Minor | Should Be 01
            $Version.Build | Should Be 03
            $Version.Revision | Should Be 100
            $End | Should Be "</FileVersion>"
        }
    }

    Context "TargetFramework" {
        It "Returns net6.0" {
            $Start, $Version, $End = Find-Version -Line "<TargetFramework>net6.0</TargetFramework>"
            $Start | Should Be "<TargetFramework>net"
            $Version.Major | Should Be 6
            $Version.Minor | Should Be 0
            $Version.Build | Should Be -1
            $Version.Revision | Should Be -1
            $End | Should Be "</TargetFramework>"
        }
    }

    AfterAll {
        Remove-Module DTFindVersion
    }
}