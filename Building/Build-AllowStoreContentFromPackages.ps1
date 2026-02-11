
<# SPDX-LICENSE-IDENTIFIER: 0BSD #>

[CmdletBinding()]
Param
(
	[Parameter()]
		[ValidateNotNull()]
		[AllowEmptyCollection()]
			$AssemblyPaths = @((Join-Path $PSScriptRoot '../../../Assemblies/1.67')),

	[Parameter()]
		[ValidateNotNull()]
			$Configuration = 'Release'
)

. (Join-Path $PSScriptRoot ../Common.ps1)
$Data = & (Join-Path $PSScriptRoot ../Data.ps1)

$TargetFramework = 'net20'

$BuildPath = $Data.BuildBinPath
$AllowStoreContentFromPackagesPath = $Data.AllowStoreContentFromPackagesPath
$AllowStoreContentFromPackagesBuildSuffix = "$Configuration/$TargetFramework"
$AllowStoreContentFromPackagesAssemblyPrefix = $Data.AllowStoreContentFromPackagesAssemblyPrefix

New-Item -ItemType Directory -Force -Path $BuildPath > $Null


dotnet `
	build `
	"-c=$Configuration" `
	"-p:TargetFramework=$TargetFramework" `
	"-p:$(if ($PSNativeCommandArgumentPassing -eq 'Legacy') {'\'})`"AssemblyPath=$BuildPath;$([String]::Join(';', $AssemblyPaths))$(if ($PSNativeCommandArgumentPassing -eq 'Legacy') {'\'})`"" `
	$AllowStoreContentFromPackagesPath `
| Write-Host

if ($LASTEXITCODE -ne 0)
{
	exit $LASTEXITCODE
}

Write-Host $AllowStoreContentFromPackagesAssemblyPrefix

Get-ChildItem -Recurse -LiteralPath (Join-Path $AllowStoreContentFromPackagesPath "bin/$AllowStoreContentFromPackagesBuildSuffix") | % `
{
	if ($_.Name.StartsWith($AllowStoreContentFromPackagesAssemblyPrefix))
	{
		Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $BuildPath $_.Name)
	}
}

