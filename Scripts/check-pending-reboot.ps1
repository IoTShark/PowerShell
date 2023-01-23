﻿<#
.SYNOPSIS
	Check for pending reboots
.DESCRIPTION
	This PowerShell script queries pending reboots and prints it.
.EXAMPLE
	./check-pending-reboot.ps1
.LINK
        https://github.com/fleschutz/PowerShell
.NOTES
        Author: Markus Fleschutz | License: CC0
#>

function Test-RegistryValue { param([parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$Path, [parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()]$Value)
	try {
		Get-ItemProperty -Path $Path -Name $Value -EA Stop
		return $true
	} catch {
		return $false
	}
}

try {
	$Reason = ""
	if ($IsLinux) {
		if (Test-Path "/var/run/reboot-required") {
			$Reason = "found /var/run/reboot-required"
		}
	} else {
		if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") {
			$Reason += ", found registry entry '...\WindowsUpdate\Auto Update\RebootRequired'"
		}
		if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\PostRebootReporting") {
			$Reason += ", found registry entry '...\WindowsUpdate\Auto Update\PostRebootReporting'"
		}
		if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") {
			$Reason += ", found registry entry '...\Component Based Servicing\RebootPending'"
		}
		if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\ServerManager\CurrentRebootAttempts") {
			$Reason += ", found registry entry '...\ServerManager\CurrentRebootAttempts'"
		}
		if (Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Value "RebootInProgress") {
			$Reason += ", found registry entry '...\CurrentVersion\Component Based Servicing' with 'RebootInProgress'"
		}
		if (Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Value "PackagesPending") {
			$Reason += ", found registry entry '...\CurrentVersion\Component Based Servicing' with 'PackagesPending'"
		}
		#if (Test-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Value "PendingFileRenameOperations") {
		#	$Reason += ", found registry entry '...\CurrentControlSet\Control\Session Manager' with 'PendingFileRenameOperations'"
		#}
		if (Test-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Value "PendingFileRenameOperations2") {
			$Reason += ", found registry entry '...\CurrentControlSet\Control\Session Manager' with 'PendingFileRenameOperations2'"
		}
		if (Test-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -Value "DVDRebootSignal") {
			$Reason += ", found registry entry '...\Windows\CurrentVersion\RunOnce' with 'DVDRebootSignal'"
		}
		if (Test-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon" -Value "JoinDomain") {
			$Reason += ", found registry entry '...\CurrentControlSet\Services\Netlogon' with 'JoinDomain'"
		}
		if (Test-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon" -Value "AvoidSpnSet") {
			$Reason += ", found registry entry '...\CurrentControlSet\Services\Netlogon' with 'AvoidSpnSet'"
		}
	}
	if ($Reason -ne "") {
		Write-Host "⚠️ Pending reboot ($($Reason.substring(2)))"
	} else {
		Write-Host "✅ No pending reboot"
	}
	exit 0 # success
} catch {
        "⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
        exit 1
}