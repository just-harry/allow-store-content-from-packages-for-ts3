
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

$ScriptRoot = $PSScriptRoot

. (Join-Path $PSScriptRoot ../Common.ps1)

$Arguments = @{AssemblyPaths = $AssemblyPaths; Configuration = $Configuration}

ForEach-InParallel $(
	,@('Build-AllowStoreContentFromPackages.ps1')
) `
{
	if (-not $IsSerial)
	{
		$Arguments = $Using:Arguments
		$ScriptRoot = $Using:ScriptRoot
	}

	foreach ($Script in $_)
	{
		& (Join-Path $ScriptRoot $Script) @Arguments
	}
}

