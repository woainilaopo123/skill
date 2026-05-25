[CmdletBinding()]
param(
    [string]$AuthorEmail = "gaojunzhe@zoesoft.com.cn",
    [string]$ProjectsRoot = "F:\\",
    [string]$ProjectPattern = "onelink_*",
    [Nullable[datetime]]$Since,
    [Nullable[datetime]]$Until,
    [switch]$IncludeMerges
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-LastWeekRange {
    $today = Get-Date
    $daysSinceMonday = ([int]$today.DayOfWeek + 6) % 7
    $thisWeekMonday = $today.Date.AddDays(-$daysSinceMonday)
    $lastWeekMonday = $thisWeekMonday.AddDays(-7)
    $lastWeekSunday = $thisWeekMonday.AddSeconds(-1)

    [PSCustomObject]@{
        Since = $lastWeekMonday
        Until = $lastWeekSunday
    }
}

function Get-GitRepos {
    param(
        [string]$Root,
        [string]$Pattern
    )

    Get-ChildItem -Path $Root -Directory -Filter $Pattern | ForEach-Object {
        Get-ChildItem -Path $_.FullName -Directory -ErrorAction SilentlyContinue |
            Where-Object { Test-Path (Join-Path $_.FullName ".git") } |
            Select-Object -ExpandProperty FullName
    }
}

if (-not $Since -or -not $Until) {
    $range = Get-LastWeekRange
    if (-not $Since) { $Since = $range.Since }
    if (-not $Until) { $Until = $range.Until }
}

$repos = @(Get-GitRepos -Root $ProjectsRoot -Pattern $ProjectPattern)

if (-not $repos) {
    throw "No git repositories found under $ProjectsRoot$ProjectPattern\\*"
}

$records = foreach ($repo in $repos) {
    $gitArgs = @(
        "-C", $repo,
        "log",
        "--all",
        "--author=$AuthorEmail",
        "--since=$($Since.ToString("yyyy-MM-dd HH:mm:ss"))",
        "--until=$($Until.ToString("yyyy-MM-dd HH:mm:ss"))",
        "--date=short",
        "--pretty=format:%ad`t%s"
    )

    if (-not $IncludeMerges) {
        $gitArgs += "--no-merges"
    }

    $output = & git @gitArgs
    if (-not $output) {
        continue
    }

    foreach ($line in $output) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        $parts = $line -split "`t", 2
        if ($parts.Count -lt 2) {
            continue
        }

        [PSCustomObject]@{
            Date = [datetime]::ParseExact($parts[0], "yyyy-MM-dd", $null)
            Repo = Split-Path $repo -Leaf
            Subject = $parts[1].Trim()
        }
    }
}

$records = @($records)

$dateCursor = $Since.Date
while ($dateCursor -le $Until.Date) {
    $dayRecords = $records | Where-Object { $_.Date.Date -eq $dateCursor }

    if (-not $dayRecords) {
        Write-Output ("{0} No commits" -f $dateCursor.ToString("yyyy-MM-dd"))
        $dateCursor = $dateCursor.AddDays(1)
        continue
    }

    $segments = $dayRecords |
        Group-Object Repo, Subject |
        Sort-Object Name |
        ForEach-Object {
            $repoName = $_.Group[0].Repo
            $subject = $_.Group[0].Subject
            $countSuffix = if ($_.Count -gt 1) { " (x$($_.Count))" } else { "" }
            "$repoName $subject$countSuffix"
        }

    Write-Output ("{0} {1}" -f $dateCursor.ToString("yyyy-MM-dd"), ($segments -join "; "))
    $dateCursor = $dateCursor.AddDays(1)
}
