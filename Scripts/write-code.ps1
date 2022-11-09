﻿<#
.SYNOPSIS
	Writes code
.DESCRIPTION
	This PowerShell script generates and writes PowerShell code on the console (for fun).
.PARAMETER speed
	Specifies the speed in milliseconds per code line
.EXAMPLE
	PS> ./write-code
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

param([int]$Speed = 500) # milliseconds

function GetRandomCodeLine { 
	$Generator = New-Object System.Random
	$Num = [int]$Generator.next(0, 24)
	switch($Num) {
	 0 { return "    `$count = 0" }
	 1 { return "    `$count++" }
	 2 { return "    exit 0 # success" }
	 3 { return "    `$Files = Get-ChildItem C:" }
	 4 { return "    Start-Sleep 1" }
	 5 { return "    `$Generator = New-Object System-Random" }
	 6 { return "} else {" }
	 7 { return "} catch {" }
	 8 { return "} elseif (`$count -eq 0) {" }
	 9 { return "    Write-Host `"Hello World`" " }
	10 { return "    while (`$true) {" }
	11 { return "# next part:" }
	12 { return "    exit 1 # failed" }
	13 { return "    return 1" }
	14 { return "    return 0" }
	15 { return "    Write-Progress `"Working...`" " }
	16 { return "    [bool]`$KeepAlive = `$true" }
	17 { return "# Copyright © 2022 write-code.ps1. All Rights Reserved." }
	18 { return "    for ([int]`$i = 0; `$i -lt 100; `$i++) {" }
	19 { return "    `$StopWatch = [system.diagnostics.stopwatch]::startNew()" }
	20 { return "    [int]`$Elapsed = `$StopWatch.Elapsed.TotalSeconds" }
	21 { return "    if (`$count -eq 0) { `$count = Read-Host `"Enter number of iterations`" " }
	22 { return "    } finally {" }
	23 { return "    throw `"Can't open file`" " }
	}
}

try {
	Write-Host -foreground green "try {"
	while ($true) {
		Write-Host -foreground green "$(GetRandomCodeLine)"
		Start-Sleep -milliseconds $Speed
	}
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}