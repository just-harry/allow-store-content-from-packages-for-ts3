
<# SPDX-LICENSE-IDENTIFIER: 0BSD #>

[CmdletBinding()]
Param
(
	[Parameter()]
		[ValidateNotNull()]
			$Configuration = 'Release',

	[Parameter()]
			[Switch] $SkipBuild
)

$Data = & (Join-Path $PSScriptRoot ../Data.ps1)

if (-not $SkipBuild)
{
	& (Join-Path $PSScriptRoot Build-All.ps1) -Configuration $Configuration
}


$BuildBinPath = $Data.BuildBinPath
$PackagePath = $Data.PackageRoot
$PackageSuffix = $Data.PackageSuffix
$AllowStoreContentFromPackagesPath = $Data.AllowStoreContentFromPackagesPath
$PackagedAllowStoreContentFromPackagesPath = Join-Path $PackagePath "$Configuration/$PackageSuffix"
$OutputPackagePath = Join-Path $PackagedAllowStoreContentFromPackagesPath just-harry-allow-store-content-from-packages.package

Remove-Item -Recurse -Force $PackagedAllowStoreContentFromPackagesPath -ErrorAction Ignore
New-Item -ItemType Directory -Force -Path $PackagedAllowStoreContentFromPackagesPath -ErrorAction Stop > $Null


$BaseResourceID = 'just-harry-allow-store-content-from-packages'


$OutputPackage = [s3pi.Package.Package]::NewPackage(1)

$AllowStoreContentFromPackagesAssembly = [s3pi.WrapperDealer.WrapperDealer]::CreateNewResource(1, '0x073FAA07')
$AllowStoreContentFromPackagesAssembly.Version = 2
$AllowStoreContentFromPackagesAssembly.GameVersion = '1.0.0.18'
$AllowStoreContentFromPackagesAssembly.Assembly = [IO.BinaryReader]::new([IO.MemoryStream]::new([IO.File]::ReadAllBytes((Join-Path $BuildBinPath AllowStoreContentFromPackages.dll))))

$OutputPackage.AddResource([s3pi.Interfaces.TGIBlock]::new(1, $Null, 0x073FAA07, 0x00000000, [Security.Cryptography.FNV64]::GetHash('AllowStoreContentFromPackages.ModEntryPoint')), $AllowStoreContentFromPackagesAssembly.Stream, $False).Compressed = 0xFFFF

$OutputPackage.SaveAs($OutputPackagePath)

