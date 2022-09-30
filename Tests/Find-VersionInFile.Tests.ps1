Describe "Find-VersionInFile" {
    BeforeAll {
         Import-Module $PSScriptRoot\..\DTFindVersion.psm1
    }

    Context "Version in Version.txt" {
        It "Returns 1.2.3" {
            $FilePath = "$PSScriptRoot\Version-Test.txt"
            $Start, $Version, $End = Find-VersionInFile -FilePath $FilePath -VersionTag "Version "
            $Start | Should Be "Version "
            $Version.Major | Should Be 1
            $Version.Minor | Should Be 2
            $Version.Build | Should Be 3
            $Version.Revision | Should Be -1
            $End | Should Be ""
        }
    }

   AfterAll {
        Remove-Module DTFindVersion
    }
}