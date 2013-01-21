<#
.SYNOPSIS
#>
Param(
        [Parameter(Position=0, Mandatory=$True)][ValidatePattern('^[\w\.]+$')]$Hostname,
        [Parameter(Position=1, Mandatory=$True)][ValidateSet("A","B","C","D","E","F","G","H","J","K","L","M","N","O","S","MS","PF","SE")]$Pod,
        [Parameter(Position=2, Mandatory=$True)]$Role,
        [Parameter(Position=3, Mandatory=$False)]$Version,
        [Parameter(Position=4, Mandatory=$False)]$SelectVersion,
        [Parameter(Position=5, Mandatory=$False)]$Branch,
        [Parameter(Position=6, Mandatory=$False)]$Build,
        [Parameter(Position=7, Mandatory=$False)]$BuildDir,
        [Parameter(Position=8, Mandatory=$False)]$KeyFile,
        [Parameter(Position=9, Mandatory=$False)][ValidateSet("Up","Down","Pending","Unknown")]$Status,
        [Parameter(Position=10, Mandatory=$False)]$Credential,
        [Parameter(Position=11, Mandatory=$False)]$Password,
        [Parameter(Position=12, Mandatory=$False)][switch]$UseDefaultCredential
)

# set debug preference
if ("$DebugPreference".CompareTo("Inquire") -eq 0) { $DebugPreference = "Continue"; $d = $True }

# scriptname
$ME = $MyInvocation.InvocationName

$MERoot = Split-Path -parent $MyInvocation.MyCommand.Definition

function Usage([int]$ExitCode)
{
    Write-Host "Usage: $ME -Hostname <Hostname> -Pod <Pod> -Role <Role> [-Version <Version>] [-SelectVersion <Version>] [-Branch <Branch>] [-Build <Build>] [-BuildDir <BuildDir>] [-KeyFile <KeyFile>] [-Credential <PSCredential>] [-Password <Password>] [-UseDefaultCredential] [-Debug]"
    Exit($ExitCode)
}

# source common functions
. $MeRoot/Functions.ps1

# check parameter usage
if ($BuildDir -eq $null -and ($Branch -eq $null -and $KeyFile -eq $null) -and ($Branch -eq $null -and $Build -eq $null) -and $Status -ne 'Pending') {
    Write-Error "missing param:  -BuildDir or (-Branch and -Build) or (-Branch and -KeyFile)"
    Usage(1)
}
# if ($BuildDir -and !(Test-Path $BuildDir)) {
#    Write-Warning "not found: $BuildDir"
#}
if ($KeyFile -and !(Test-Path $KeyFile)) {
    Write-Error "not found: $KeyFile"
    Usage(1)
}

# default values
$ListName = 'Pod Details'
$Uri =  'http://compass2.webtrends.corp/private/eng/systems/_vti_bin/Lists.asmx?wsdl'

# deal with password first
if ($Password) {
    Write-Debug "Securing Password"
    $SecurePassword = ConvertTo-SecureString -AsPlainText -Force -String $Password
    Remove-Variable Password
}

Write-Debug "Hostname: $Hostname"
Write-Debug "Pod: $Pod"
Write-Debug "Role: $Role"
Write-Debug "Version: $Version"
Write-Debug "SelectVersion: $SelectVersion"
Write-Debug "Branch: $Branch"
Write-Debug "Build: $Build"
Write-Debug "BuildDir: $BuildDir"
Write-Debug "KeyFile: $KeyFile"
Write-Debug "Status: $Status"
Write-Debug "Credential: $Credential"
Write-Debug "Password: $SecurePassword"
Write-Debug "UseDefaultCredential: $UseDefaultCredential"
   
if ($Credential -and $SecurePassword) {
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Credential, $SecurePassword
} elseif ($Credential) {
    $Credential = Get-Credential -Credential $Credential
} elseif ($UseDefaultCredential -eq $False) {
    $Credential = Get-Credential
}

# clean up hostname
if ($Hostname -match "^([^\.]+)\..*$") {
    $Hostname = $matches[1]
}
$Hostname = $Hostname.ToLower()
Write-Debug "Using Hostname: $Hostname"

# create the CAML query to get record
$xml = New-Object System.Xml.XmlDocument
$query = $xml.CreateElement("Query") 
$qryHostname = $xml.CreateElement("Eq")
$qryHostname.InnerXml = "<FieldRef Name='Title' /><Value Type='Text'>$Hostname</Value>"
$qryPod = $xml.CreateElement("Eq")
$qryPod.InnerXml = "<FieldRef Name='POD' /><Value Type='Text'>$Pod</Value>"
$qryRole = $xml.CreateElement("Eq")
$qryRole.InnerXml = "<FieldRef Name='Role' /><Value Type='Text'>$Role</Value>"
$qryCondition1 = $xml.CreateElement("And")
[void]$qryCondition1.AppendChild($qryHostname)
[void]$qryCondition1.AppendChild($qryPod)
if ($SelectVersion) {
    $qryCondition2 = $xml.CreateElement("And")
    [void]$qryCondition2.AppendChild($qryRole)
    $qryVersion = $xml.CreateElement("Eq")
    $qryVersion.InnerXml = "<FieldRef Name='_Version' /><Value Type='Text'>$SelectVersion</Value>"
    [void]$qryCondition2.AppendChild($qryVersion)
} else {
    $qryCondition2 = $qryRole
}
$qryWhere = $xml.CreateElement("Where")
$qryCondition = $xml.CreateElement("And")
[void]$qryCondition.AppendChild($qryCondition1)
[void]$qryCondition.AppendChild($qryCondition2)
[void]$qryWhere.AppendChild($qryCondition)
[void]$query.AppendChild($qryWhere)

# create query options
$queryOptions = $xml.CreateElement("QueryOptions")
$queryOptions.InnerXml = "<IncludeMandatoryColumns>True</IncludeMandatoryColumns>"

# create a proxy for the web service
Write-Debug "Connecting to $Uri"
if ($UseDefaultCredential -eq $True) {
    $ws = New-WebServiceProxy -Uri $Uri -UseDefaultCredential
} else {
    $ws = New-WebServiceProxy -Uri $Uri -Credential $Credential
}

Write-Debug "Query for $Hostname"
if ($d) { ($query.OuterXml | format-xml) }
$items = $ws.GetListItems($listName, $null, $query, $null, $null, $queryOptions, $null)
if ($d) { $items.data.row }

# check if we only got 1 result
if ($items.data.ItemCount -eq 0) {
    Write-Output "No records found.  Nothing to update."
    Exit(0)
} elseif ($items.data.ItemCount -gt 1) {
    Write-Output "More than 1 record found.  Refine criteria.  No update performed."
    $items.data.row | format-table -Property ows_ID,ows_Title,ows_POD,ows_Role,ows__Version,ows_Branch,ows_Build,ows__Status | Out-Default
    Exit(0)
}

Write-Debug "Got 1 record."
Write-Host "Pod Details: BEFORE" -ForegroundColor Yellow -NoNewline
$items.data.row | format-list -Property ows_ID,ows_Title,ows_POD,ows_Role,ows__Version,ows_Branch,ows_Build,ows__Status | Out-Default

# determine branch and build
if ($BuildDir) {

    # regex for TFS build folders
    if ($BuildDir -replace '`', '' -match '([\w\s\.]+?)_(\d{8}\.\d+\.?[\+\.\d\[\]\w]*)_?.*?$') {
        $Branch = $matches[1]
        if ($Build -eq $null) { $Build = $matches[2] }
        $BuildType = 1
    # regex for TeamCity build folders
    } elseif ($BuildDir -replace '`', '' -match '([\w\s\.\-]+?)_([\d\.]+?)(_artifacts)?$') {
        $Branch = $matches[1]
        if ($Build -eq $null) { $Build = $matches[2] }
        $BuildType = 2
    # others
    } elseif ($BuildDir -replace '`', '' -match '[\\\/]?([^\\\/]+?)[\\\/]?$') {
        $Branch = $matches[1]
        $BuildType = 3
    }
}

if ($KeyFile) {
    Write-Host "Using Keyfile: $KeyFile`r`n"
    switch ($BuildType) {
#            1 {
#                $FileVersion = (Get-Command $KeyFile).FileVersionInfo
#                $FileVersion.FileVersion -match '([\.\d]+)\.(\d+)\.(\d+)$' | Out-Null
#                $FileVersionMatches = $matches.Clone()
#                switch -regex ($KeyFile) {
#                    "Webtrends.DataExchange" { $BuildNumber = $FileVersionMatches[2] }
#                    "WebTrends.UI.Reporting" { $BuildNumber = $FileVersionMatches[2] }
#                    "WebTrends.RTA.exe"      { $BuildNumber = $FileVersionMatches[2] }
#                    "WebTrends.RTE.exe"      { $BuildNumber = $FileVersionMatches[2] }
#                    default                  { $BuildNumber = $FileVersionMatches[3] }
#                }
#                if ($Build -match '(.*?)\.?\[.*\]$') {
#                    $Build = $matches[1] + '.[' + $BuildNumber + ']'
#                } else {
#                    $Build = $Build + '.[' + $BuildNumber + ']'
#                }
#            }
            default {
                $FileVersion = (Get-Command $KeyFile).FileVersionInfo
                $Build = $FileVersion.FileVersion
            }
    }
}

# special case for Common Lib
if ($Role -eq 'Common Lib' -and $Build -eq $null ) { $Build = '-' }

if ($Branch -eq $null -and $Status -ne 'Pending') { Write-Error "Unable to determine branch." }
if ($Build -eq $null -and $Status -ne 'Pending') { Write-Error "Unable to determine build." }
if (($Branch -eq $null -or $Build -eq $null) -and $Status -ne 'Pending') { Write-Output "BuildDir: $BuildDir"; Exit(1) }

Write-Debug "Branch: $Branch"
Write-Debug "Build: $Build"

# determine if fields are different
$PerformUpdate = $False
if ($Version -and $Version.CompareTo($items.data.row.ows__Version)) { $PerformUpdate = $True }
if ($Branch  -and $Branch.CompareTo($items.data.row.ows_Branch))    { $PerformUpdate = $True }
if ($Build   -and $Build.CompareTo($items.data.row.ows_Build))      { $PerformUpdate = $True }
if ($Status  -and $Status.CompareTo($items.data.row.ows__Status))   { $PerformUpdate = $True }

# if no fields have changed, then skip the update
if ($PerformUpdate -eq $False) {
    Write-Host "Pod Detail field values are the same.  No update performed." -ForegroundColor Yellow
    Write-Debug "
Version: $Version
Branch : $Branch
Build  : $Build
Status : $Status"
    Exit(0)
}

# get list and view
$ndlistview = $ws.GetListAndView($listName, $null)
$listID = $ndlistview.ChildNodes.Item(0).GetAttribute("Name")
$viewID = $ndlistview.ChildNodes.Item(1).GetAttribute("Name")

# create the CAML query to update record
$updBatch = $xml.CreateElement("Batch")
$updBatch.SetAttribute("OnError", "Continue")
$updBatch.SetAttribute("ListVersion", "1")
$updBatch.SetAttribute("ViewName", $viewID)
$updMethod1 = $xml.CreateElement("Method")
$updMethod1.SetAttribute("ID","1")
$updMethod1.SetAttribute("Cmd","Update")
$updFieldID = $xml.CreateElement("Field")
$updFieldID.SetAttribute("Name", "ID")
$updFieldID.InnerXml = $items.data.row.ows_ID
[void]$updMethod1.AppendChild($updFieldID)
if ($Version) {
    $updFieldVersion = $xml.CreateElement("Field")
    $updFieldVersion.SetAttribute("Name", "_Version")
    $updFieldVersion.InnerXml = $Version
    [void]$updMethod1.AppendChild($updFieldVersion)
}
if ($Branch) {
    $updFieldBranch = $xml.CreateElement("Field")
    $updFieldBranch.SetAttribute("Name", "Branch")
    $updFieldBranch.InnerXml = $Branch
    [void]$updMethod1.AppendChild($updFieldBranch)
}
if ($Build) {
    $updFieldBuild = $xml.CreateElement("Field")
    $updFieldBuild.SetAttribute("Name", "Build")
    $updFieldBuild.InnerXml = $Build
    [void]$updMethod1.AppendChild($updFieldBuild)
}
if ($Status) {
    $updFieldStatus = $xml.CreateElement("Field")
    $updFieldStatus.SetAttribute("Name", "_Status")
    $updFieldStatus.InnerXml = $Status
    [void]$updMethod1.AppendChild($updFieldStatus)
}
[void]$updBatch.AppendChild($updMethod1)

Write-Debug "Updating $Hostname"
if ($d) { 
    ($updBatch.OuterXml | format-xml 2> Out-Null )
} else {
    $result = $ws.UpdateListItems($listID, $updBatch)
}

$items = $ws.GetListItems($listName, $null, $query, $null, $null, $queryOptions, $null)
Write-Host "Pod Details: AFTER" -ForegroundColor Yellow -NoNewline
$items.data.row | format-list -Property ows_ID,ows_Title,ows_POD,ows_Role,ows__Version,ows_Branch,ows_Build,ows__Status | Out-Default
