Describe "Update-Version" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\DTFindVersion.psm1


    }

    Context "Increment 2 Digits" {
        BeforeAll {
            $Version =[version]::new(1, 2)
        }

        It "Returns 2.2" {
            $NewVersion = Update-Version -Version $Version -Increment Major
            $NewVersion.Major | Should Be ($Version.Major + 1)
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.3" {
            $NewVersion = Update-Version -Version $Version -Increment Minor
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be ($Version.Minor + 1)
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2" {
            $NewVersion = Update-Version -Version $Version -Increment Build
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2" {
            $NewVersion = Update-Version -Version $Version -Increment Revision
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }
    }

    Context "Increment 2 Digits zeroes" {
        BeforeAll {
            $Version =[version]::new(0, 0)
        }

        It "Returns 2.2" {
            $NewVersion = Update-Version -Version $Version -Increment Major
            $NewVersion.Major | Should Be ($Version.Major + 1)
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.3" {
            $NewVersion = Update-Version -Version $Version -Increment Minor
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be ($Version.Minor + 1)
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2" {
            $NewVersion = Update-Version -Version $Version -Increment Build
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2" {
            $NewVersion = Update-Version -Version $Version -Increment Revision
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }
    }


    Context "Increment 3 Digits" {
        BeforeAll {
            $Version =[version]::new(1, 2, 3)
        }

        It "Returns 2.2.3" {
            $NewVersion = Update-Version -Version $Version -Increment Major
            $NewVersion.Major | Should Be ($Version.Major + 1)
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.3.3" {
            $NewVersion = Update-Version -Version $Version -Increment Minor
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be ($Version.Minor + 1)
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2.4" {
            $NewVersion = Update-Version -Version $Version -Increment Build
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be ($Version.Build + 1)
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2.3" {
            $NewVersion = Update-Version -Version $Version -Increment Revision
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }
    }

    Context "Increment 3 Digits zeroes" {
        BeforeAll {
            $Version =[version]::new(0, 0, 0)
        }

        It "Returns 1.0.0" {
            $NewVersion = Update-Version -Version $Version -Increment Major
            $NewVersion.Major | Should Be ($Version.Major + 1)
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 0.1.0" {
            $NewVersion = Update-Version -Version $Version -Increment Minor
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be ($Version.Minor + 1)
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 0.0.1" {
            $NewVersion = Update-Version -Version $Version -Increment Build
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be ($Version.Build + 1)
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 0.0.0" {
            $NewVersion = Update-Version -Version $Version -Increment Revision
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }
    }

    Context "Increment 4 Digits" {
        BeforeAll {
            $Version =[version]::new(1, 2, 3, 4)
        }

        It "Returns 2.2.3.4" {
            $NewVersion = Update-Version -Version $Version -Increment Major
            $NewVersion.Major | Should Be ($Version.Major + 1)
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.3.3.4" {
            $NewVersion = Update-Version -Version $Version -Increment Minor
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be ($Version.Minor + 1)
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2.4.4" {
            $NewVersion = Update-Version -Version $Version -Increment Build
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be ($Version.Build + 1)
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2.3.5" {
            $NewVersion = Update-Version -Version $Version -Increment Revision
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be ($Version.Revision + 1)
        }
    }

    Context "Increment 4 Digits zeroes" {
        BeforeAll {
            $Version =[version]::new(0, 0, 0, 0)
        }

        It "Returns 1.0.0.0" {
            $NewVersion = Update-Version -Version $Version -Increment Major
            $NewVersion.Major | Should Be ($Version.Major + 1)
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 0.1.0.0" {
            $NewVersion = Update-Version -Version $Version -Increment Minor
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be ($Version.Minor + 1)
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 0.0.1.0" {
            $NewVersion = Update-Version -Version $Version -Increment Build
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be ($Version.Build + 1)
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 0.0.0.1" {
            $NewVersion = Update-Version -Version $Version -Increment Revision
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be ($Version.Revision + 1)
        }
    }

    Context "Generate 4 Digits" {
        BeforeAll {
            $Now = Get-Date -Month 11 -Day 12 -Year 1955 -Hour 06 -Minute 38 -Second 11
            $Version =[version]::new(1, 2, 3, 4)
        }

        It "Returns 1.2.3162389" {
            $NewVersion = Update-Version -Version $Version -Generate Build -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 3162389
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2.3.3162389" {
            $NewVersion = Update-Version -Version $Version -Generate Revision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be 3162389
        }

        It "Returns 1.2.316.2389" {
            $NewVersion = Update-Version -Version $Version -Generate BuildAndRevision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 316
            $NewVersion.Revision | Should Be 2389
        }
    }

    Context "Generate 4 Digits Zeroes" {
        BeforeAll {
            $Now = Get-Date -Month 11 -Day 12 -Year 1955 -Hour 06 -Minute 38 -Second 11
            $Version =[version]::new(0, 0, 0, 0)
        }

        It "Returns 0.0.3162389" {
            $NewVersion = Update-Version -Version $Version -Generate Build -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 3162389
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 0.0.0.3162389" {
            $NewVersion = Update-Version -Version $Version -Generate Revision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be 3162389
        }

        It "Returns 0.0.316.2389" {
            $NewVersion = Update-Version -Version $Version -Generate BuildAndRevision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 316
            $NewVersion.Revision | Should Be 2389
        }
    }

    Context "Generate 3 Digits" {
        BeforeAll {
            $Now = Get-Date -Month 11 -Day 12 -Year 1955 -Hour 06 -Minute 38 -Second 11
            $Version =[version]::new(1, 2, 3)
        }

        It "Returns 1.2.3162389" {
            $NewVersion = Update-Version -Version $Version -Generate Build -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 3162389
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2.3" {
            $NewVersion = Update-Version -Version $Version -Generate Revision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2.316.2389" {
            $NewVersion = Update-Version -Version $Version -Generate BuildAndRevision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 316
            $NewVersion.Revision | Should Be $Version.Revision
        }
    }

    Context "Generate 3 Digits Zeroes" {
        BeforeAll {
            $Now = Get-Date -Month 11 -Day 12 -Year 1955 -Hour 06 -Minute 38 -Second 11
            $Version =[version]::new(0, 0, 0)
        }

        It "Returns 0.0.3162389" {
            $NewVersion = Update-Version -Version $Version -Generate Build -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 3162389
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 0.0.0" {
            $NewVersion = Update-Version -Version $Version -Generate Revision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 0.0.316.2389" {
            $NewVersion = Update-Version -Version $Version -Generate BuildAndRevision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 316
            $NewVersion.Revision | Should Be $Version.Revision
        }
    }

    Context "Generate 2 Digits" {
        BeforeAll {
            $Now = Get-Date -Month 11 -Day 12 -Year 1955 -Hour 06 -Minute 38 -Second 11
            $Version =[version]::new(1, 2)
        }

        It "Returns 1.2" {
            $NewVersion = Update-Version -Version $Version -Generate Build -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2" {
            $NewVersion = Update-Version -Version $Version -Generate Revision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2" {
            $NewVersion = Update-Version -Version $Version -Generate BuildAndRevision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }
    }

    Context "Generate 2 Digits Zeroes" {
        BeforeAll {
            $Now = Get-Date -Month 11 -Day 12 -Year 1955 -Hour 06 -Minute 38 -Second 11
            $Version =[version]::new(0, 0)
        }

        It "Returns 0.0" {
            $NewVersion = Update-Version -Version $Version -Generate Build -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 0.0" {
            $NewVersion = Update-Version -Version $Version -Generate Revision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 0.0" {
            $NewVersion = Update-Version -Version $Version -Generate BuildAndRevision -Now $Now
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be $Version.Revision
        }
    }

    Context "Generate 4 Digits DayOffset 1000" {
        BeforeAll {
            $Now = Get-Date -Month 11 -Day 12 -Year 1955 -Hour 06 -Minute 38 -Second 11
            $Version =[version]::new(1, 2, 3, 4)
            $DayOffset = 1000
        }

        It "Returns 1.2.13162389" {
            $NewVersion = Update-Version -Version $Version -Generate Build -Now $Now -DayOffset $DayOffset
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 13162389
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2.3.13162389" {
            $NewVersion = Update-Version -Version $Version -Generate Revision -Now $Now -DayOffset $DayOffset
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be 13162389
        }

        It "Returns 1.2.1316.2389" {
            $NewVersion = Update-Version -Version $Version -Generate BuildAndRevision -Now $Now -DayOffset $DayOffset
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 1316
            $NewVersion.Revision | Should Be 2389
        }
    }

    Context "Generate 4 Digits DayOffset -1000" {
        BeforeAll {
            $Now = Get-Date -Month 11 -Day 12 -Year 1955 -Hour 06 -Minute 38 -Second 11
            $Version =[version]::new(1, 2, 3, 4)
            $DayOffset = -1000
        }

        It "Returns 1.2.2389" {
            $NewVersion = Update-Version -Version $Version -Generate Build -Now $Now -DayOffset $DayOffset
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 2389
            $NewVersion.Revision | Should Be $Version.Revision
        }

        It "Returns 1.2.3.2389" {
            $NewVersion = Update-Version -Version $Version -Generate Revision -Now $Now -DayOffset $DayOffset
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be $Version.Build
            $NewVersion.Revision | Should Be 2389
        }

        It "Returns 1.2.0.2389" {
            $NewVersion = Update-Version -Version $Version -Generate BuildAndRevision -Now $Now -DayOffset $DayOffset
            $NewVersion.Major | Should Be $Version.Major
            $NewVersion.Minor | Should Be $Version.Minor
            $NewVersion.Build | Should Be 0
            $NewVersion.Revision | Should Be 2389
        }
    }

    AfterAll {
        Remove-Module DTFindVersion
    }
}
