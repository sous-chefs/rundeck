<#
.SYNOPSIS
	Library of functions to support Pod Details update.

.NOTES
	Author:  David Dvorak <david.dvorak@webtrends.com>
	Copyright © 2013 Webtrends Inc.
#>

function Get-OSVersion {

	$os = Get-WmiObject -Class Win32_OperatingSystem

	switch -wildcard ($os.Version) {
		"5.*.2600" { $osname = "Windows XP" }
		"5.*.3790" {
			$osname = "Windows 2003"
			if ($env:PROCESSOR_ARCHITECTURE -eq "x86") {
				$osname += " x86"
			}
		}
		"6.0.*" {
			if ($os.ProductType -eq 1) {
				$osname = "Windows Vista"
			} else {
				$osname = "Windows 2008"
			}
			if ($os.OSArchitecture -eq "64-bit") {
				$osname += " x64"
			} else {
				$osname += " x86"
			}
		}
		"6.1.*" {
			if ($os.ProductType -eq 1) {
				$osname = "Windows 7"
			} else {
				$osname = "Windows 2008 R2"
			}
		}
		"6.2.*" {
			if ($os.ProductType -eq 1) {
				$osname = "Windows 8"
			} else {
				$osname = "Windows 2012"
			}
		}
		DEFAULT { $osname = $null }
	}
	return $osname
}

function Format-Xml {
	Param([string[]]$Path)

	begin {
		function PrettyPrintXmlString([string]$xml) {
			$tr = new-object System.IO.StringReader($xml)
			$settings = new-object System.Xml.XmlReaderSettings
			$settings.CloseInput = $true
			$settings.IgnoreWhitespace = $true
			$reader = [System.Xml.XmlReader]::Create($tr, $settings)

			$sw = new-object System.IO.StringWriter
			$settings = new-object System.Xml.XmlWriterSettings
			$settings.CloseOutput = $true
			$settings.Indent = $true
			$writer = [System.Xml.XmlWriter]::Create($sw, $settings)

			while (!$reader.EOF) {
				$writer.WriteNode($reader, $false)
			}
			$writer.Flush()

			$result = $sw.ToString()
			$reader.Close()
			$writer.Close()
			$result
		}

		function PrettyPrintXmlFile($path) {
			$rpath = resolve-path $path
			$contents = gc $rpath
			$contents = [string]::join([environment]::newline, $contents)
			PrettyPrintXmlString $contents
		}

		function Usage() {
			""
			"USAGE"
			"	Format-Xml -Path <pathToXmlFile>"
			""
			"SYNOPSIS"
			"	Formats the XML into a nicely indented form (ie pretty printed)."
			"	Outputs one <string> object for each XML file."
			""
			"PARAMETERS"
			"	-Path <string[]>"
			"		Specifies path to one or more XML files to format with indentation."
			"		Pipeline input is bound to this parameter."
			""
			"EXAMPLES"
			"	Format-Xml -Path foo.xml"
			"	Format-Xml foo.xml"
			"	gci *.xml | Format-Xml"
			"	[xml]`"<doc>…</doc>`" | Format-Xml"
			""
		}
		if (($args[0] -eq "-?") -or ($args[0] -eq "-help")) {
		  Usage
		}
	}

	process {
		if ($_) {
			if ($_ -is [xml]) {
				PrettyPrintXmlString $_.get_OuterXml()
			}
			elseif ($_ -is [IO.FileInfo]) {
				PrettyPrintXmlFile $_.FullName
			}
			elseif ($_ -is [string]) {
				if ($_ -match "<") {
					PrettyPrintXmlString $_
				} elseif (test-path $_ -pathType leaf) {
					PrettyPrintXmlFile $_
				}
				else {
					PrettyPrintXmlString $_
				}
			}
			else {
				throw "Pipeline input type must be one of: [xml], [string] or [IO.FileInfo]"
			}
		}
	}

	end {
		if ($Path) {
			foreach ($aPath in $Path) {
				PrettyPrintXmlFile $aPath
			}
		}
	}
}
