
<# SPDX-LICENSE-IDENTIFIER: 0BSD #>


if ($Null -eq $PSNativeCommandArgumentPassing)
{
	$PSNativeCommandArgumentPassing = 'Legacy'
}


function ForEach-InParallel ($InputObject, $ScriptBlock, $ThrottleLimit = [Environment]::ProcessorCount)
{
	if ($PSVersionTable.PSVersion.Major -ge 7)
	{
		$InputObject | ForEach-Object -Parallel $ScriptBlock -ThrottleLimit $ThrottleLimit
	}
	else
	{
		$IsSerial = $True
		$InputObject | ForEach-Object -Process $ScriptBlock
	}
}

