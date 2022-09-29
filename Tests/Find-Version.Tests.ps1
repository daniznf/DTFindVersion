Describe "Find-Version" {
    BeforeAll {
         Import-Module $PSScriptRoot\..\DTFindVersion.psm1
    }

    Context "AssemblyVersion 4 numbers" {
        It "Returns 1.2.3.4" {
            $Version = Find-Version -Line "[assembly: AssemblyVersion(""1.2.3.4"")]"
            $Version["Start"] | Should Be "[assembly: AssemblyVersion("""
            $Version["Major"] | Should Be 1
            $Version["Minor"] | Should Be 2
            $Version["Build"] | Should Be 3
            $Version["Revision"] | Should Be 4
            $Version["End"] | Should Be """)]"
            $Version[0] | Should Be "[assembly: AssemblyVersion(""1.2.3.4"")]"
        }
    }

    Context "AssemblyVersion 3 numbers" {
        It "Returns 1.2.3" {
            $Version = Find-Version -Line "[assembly: AssemblyVersion(""1.2.3"")]"
            $Version["Start"] | Should Be "[assembly: AssemblyVersion("""
            $Version["Major"] | Should Be 1
            $Version["Minor"] | Should Be 2
            $Version["Build"] | Should Be 3
            $Version["Revision"] | Should Be $null
            $Version["End"] | Should Be """)]"
        }
    }

    Context "AssemblyVersion 2 numbers" {
        It "Returns 1.2" {
            $Version = Find-Version -Line "[assembly: AssemblyVersion(""1.2"")]"
            $Version["Start"] | Should Be "[assembly: AssemblyVersion("""
            $Version["Major"] | Should Be 1
            $Version["Minor"] | Should Be 2
            $Version["Build"] | Should Be $null
            $Version["Revision"] | Should Be $null
            $Version["End"] | Should Be """)]"
        }
    }

    Context "AssemblyVersion 1 number" {
        It "Returns 1" {
            $Version = Find-Version -Line "[assembly: AssemblyVersion(""1"")]"
            $Version["Start"] | Should Be "[assembly: AssemblyVersion("""
            $Version["Major"] | Should Be 1
            $Version["Minor"] | Should Be $null
            $Version["Build"] | Should Be $null
            $Version["Revision"] | Should Be $null
            $Version["End"] | Should Be """)]"
        }
    }

    Context "AssemblyVersion Minor Zero " {
        It "Returns 1.0.3" {
            $Version = Find-Version -Line "[assembly: AssemblyVersion(""1.0.3"")]"
            $Version["Start"] | Should Be "[assembly: AssemblyVersion("""
            $Version["Major"] | Should Be 1
            $Version["Minor"] | Should Be 0
            $Version["Build"] | Should Be 3
            $Version["Revision"] | Should Be $null
            $Version["End"] | Should Be """)]"
        }
    }

    Context "AssemblyVersion Major Zero" {
        It "Returns 0.2.3" {
            $Version = Find-Version -Line "[assembly: AssemblyVersion(""0.2.3"")]"
            $Version["Start"] | Should Be "[assembly: AssemblyVersion("""
            $Version["Major"] | Should Be 0
            $Version["Minor"] | Should Be 2
            $Version["Build"] | Should Be 3
            $Version["Revision"] | Should Be $null
            $Version["End"] | Should Be """)]"
        }
    }

    Context "AssemblyVersion Major and Minor Zero" {
        It "Returns 0.0.3" {
            $Version = Find-Version -Line "[assembly: AssemblyVersion(""0.0.3"")]"
            $Version["Start"] | Should Be "[assembly: AssemblyVersion("""
            $Version["Major"] | Should Be 0
            $Version["Minor"] | Should Be 0
            $Version["Build"] | Should Be 3
            $Version["Revision"] | Should Be $null
            $Version["End"] | Should Be """)]"
        }
    }

    Context "AssemblyVersion Zero" {
        It "Returns 0.0.0" {
            $Version = Find-Version -Line "[assembly: AssemblyVersion(""0.0.0"")]"
            $Version["Start"] | Should Be "[assembly: AssemblyVersion("""
            $Version["Major"] | Should Be 0
            $Version["Minor"] | Should Be 0
            $Version["Build"] | Should Be 0
            $Version["Revision"] | Should Be $null
            $Version["End"] | Should Be """)]"
        }
    }

    Context "xml 3 numbers" {
        It "Returns 1.2.3" {
            $Version = Find-Version -Line "<FileVersion>1.2.3</FileVersion>"
            $Version["Start"] | Should Be "<FileVersion>"
            $Version["Major"] | Should Be 1
            $Version["Minor"] | Should Be 2
            $Version["Build"] | Should Be 3
            $Version["Revision"] | Should Be $null
            $Version["End"] | Should Be "</FileVersion>"
        }
    }

    Context "xml 3 numbers v" {
        It "Returns 1.2.3" {
            $Version = Find-Version -Line "<Version>v1.2.3</Version>"
            $Version["Start"] | Should Be "<Version>v"
            $Version["Major"] | Should Be 1
            $Version["Minor"] | Should Be 2
            $Version["Build"] | Should Be 3
            $Version["Revision"] | Should Be $null
            $Version["End"] | Should Be "</Version>"
        }
    }

    Context "xml 4 numbers and zeroes" {
        It "Returns 0.0.3.0" {
            $Version = Find-Version -Line "<FileVersion>0.0.3.0</FileVersion>"
            $Version["Start"] | Should Be "<FileVersion>"
            $Version["Major"] | Should Be 0
            $Version["Minor"] | Should Be 0
            $Version["Build"] | Should Be 3
            $Version["Revision"] | Should Be 0
            $Version["End"] | Should Be "</FileVersion>"
        }
    }

    Context "Multi digit numbers and zeroes" {
        It "Returns 0.0.13.5678" {
            $Version = Find-Version -Line "<FileVersion>0.0.13.5678</FileVersion>"
            $Version["Start"] | Should Be "<FileVersion>"
            $Version["Major"] | Should Be 0
            $Version["Minor"] | Should Be 0
            $Version["Build"] | Should Be 13
            $Version["Revision"] | Should Be 5678
            $Version["End"] | Should Be "</FileVersion>"
        }
    }

    Context "Zero-padded" {
        It "Returns 0.01.03.100" {
            $Version = Find-Version -Line "<FileVersion>0.01.03.100</FileVersion>"
            $Version["Start"] | Should Be "<FileVersion>"
            $Version["Major"] | Should Be 0
            $Version["Minor"] | Should Be 01
            $Version["Build"] | Should Be 03
            $Version["Revision"] | Should Be 100
            $Version["End"] | Should Be "</FileVersion>"
        }
    }

    Context "TargetFramework" {
        It "Returns net6.0" {
            $Version = Find-Version -Line "<TargetFramework>net6.0</TargetFramework>"
            $Version["Start"] | Should Be "<TargetFramework>net"
            $Version["Major"] | Should Be 6
            $Version["Minor"] | Should Be 0
            $Version["Build"] | Should Be $null
            $Version["Revision"] | Should Be $null
            $Version["End"] | Should Be "</TargetFramework>"
        }
    }

    AfterAll {
        Remove-Module DTFindVersion
    }
}