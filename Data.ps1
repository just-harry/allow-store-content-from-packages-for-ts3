
<# SPDX-LICENSE-IDENTIFIER: 0BSD #>

[CmdletBinding()]
Param ()

$BuildRoot = Join-Path $PSScriptRoot Build
$AllowStoreContentFromPackagesPath = Join-Path $PSScriptRoot AllowStoreContentFromPackages

[PSCustomObject] @{
	Root = $PSScriptRoot
	BuildRoot = $BuildRoot
	BuildBinPath = Join-Path $BuildRoot Bin
	PackageRoot = Join-Path $BuildRoot Package
	PackageSuffix = 'AllowStoreContentFromPackages'
	AllowStoreContentFromPackagesPath = $AllowStoreContentFromPackagesPath
	AllowStoreContentFromPackagesAssemblyPrefix = 'AllowStoreContentFromPackages'
}

