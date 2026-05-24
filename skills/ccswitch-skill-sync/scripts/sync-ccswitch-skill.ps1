param(
    [Parameter(Position = 0)]
    [string]$SkillName,

    [string]$SourceRoot = "D:\skills",

    [string]$TargetRoot = "$env:USERPROFILE\.cc-switch\skills",

    [switch]$All,

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Get-SkillDirectories {
    param(
        [string]$Root
    )

    if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
        throw "Source root does not exist: $Root"
    }

    Get-ChildItem -LiteralPath $Root -Directory |
        Where-Object {
            Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md") -PathType Leaf
        } |
        Select-Object -ExpandProperty Name
}

function Sync-OneSkill {
    param(
        [string]$Name,
        [string]$SourceRootPath,
        [string]$TargetRootPath,
        [bool]$PreviewOnly
    )

    $sourcePath = Join-Path $SourceRootPath $Name
    $targetPath = Join-Path $TargetRootPath $Name

    if (-not (Test-Path -LiteralPath $sourcePath -PathType Container)) {
        throw "Source skill does not exist: $sourcePath"
    }

    if (-not (Test-Path -LiteralPath (Join-Path $sourcePath "SKILL.md") -PathType Leaf)) {
        throw "Source skill is missing SKILL.md: $sourcePath"
    }

    if (-not (Test-Path -LiteralPath $TargetRootPath -PathType Container)) {
        New-Item -ItemType Directory -Path $TargetRootPath | Out-Null
    }

    $targetExists = Test-Path -LiteralPath $targetPath -PathType Container
    $mode = if ($targetExists) { "update" } else { "create" }

    $robocopyArgs = @(
        $sourcePath
        $targetPath
        "/MIR"
        "/R:2"
        "/W:1"
        "/XD"
        ".git"
        ".idea"
    )

    if ($PreviewOnly) {
        $robocopyArgs += "/L"
    }

    & robocopy @robocopyArgs | Out-Host
    $exitCode = $LASTEXITCODE

    if ($exitCode -gt 7) {
        throw "robocopy failed with exit code: $exitCode"
    }

    [PSCustomObject]@{
        SkillName = $Name
        Mode = $mode
        SourcePath = $sourcePath
        TargetPath = $targetPath
        DryRun = $PreviewOnly
        ExitCode = $exitCode
    }
}

if ($All -and -not [string]::IsNullOrWhiteSpace($SkillName)) {
    throw "Do not use -All and -SkillName together."
}

if (-not $All -and [string]::IsNullOrWhiteSpace($SkillName)) {
    throw "Provide -SkillName or use -All."
}

$skillNames = if ($All) {
    Get-SkillDirectories -Root $SourceRoot
} else {
    @($SkillName)
}

$results = foreach ($name in $skillNames) {
    Sync-OneSkill -Name $name -SourceRootPath $SourceRoot -TargetRootPath $TargetRoot -PreviewOnly $DryRun.IsPresent
}

""
"Sync results:"
$results | ForEach-Object {
    "- $($_.SkillName): mode=$($_.Mode); dryRun=$($_.DryRun); source=$($_.SourcePath); target=$($_.TargetPath)"
}
