<#
===========================================================================
Created on:   	04/02/2020 12:45
Created by:   	Ben Whitmore
Organization: 	
Filename:     	Set-FileAssoc.ps1
-------------------------------------------------------------------------
Script Name: Set-FileAssoc
===========================================================================
    
Version:

1.2.4.0   26/01/2020  Ben Whitmore

.DESCRIPTION
Script to create Custom File Associations XML for use with GPO / DISM

.PARAMETER Browser
Specify which browser to set as the default. Choice of "Edge", "Chrome", "Firefox", "IE"

.PARAMETER PDF
Specify which PDF application to set as default. Choice of "AcrobatDC","ReaderDC","Edge"

.PARAMETER LOG
Specify which LOG application to set as default. Choice of "CMTrace", "Notepad"

.EXAMPLE
Set-FileAssoc.ps1 -Browser Edge -PDF Edge -LOG CMTrace
#>

[cmdletbinding()]
Param
(
    [Parameter(Mandatory = $False)]
    [ValidateSet('Edge', 'Chrome', 'Firefox','IE')]
    [String]$Browser,
    [Parameter(Mandatory = $False)]
    [ValidateSet('AcrobatDC', 'ReaderDC', 'Edge')]
    [String]$PDF,
    [Parameter(Mandatory = $False)]
    [ValidateSet('CMTrace', 'Notepad')]
    [String]$LOG  
)

#Set Variable for Current Working Directory
$ScriptPath = $MyInvocation.MyCommand.Path
$CurrentDir = Split-Path $ScriptPath

#Set Variable for Master Associations XML
$Associations_Master = Join-Path $CurrentDir Associations_Master.xml

[xml]$Associations_FileType = Get-Content $Associations_Master

#Set Variable for New Custom Associations XML
$Custom_FileAssociations = Join-Path $ENV:Windir Custom_FileAssociations.xml

#Backup existing Custom Associations XML File
If (Test-Path $Custom_FileAssociations) {
    Rename-Item -Path $Custom_FileAssociations -NewName ("Custom_FileAssociations_" + (Get-Date -uformat "%Y-%m-%d_%H-%M-%S") + ".xml") -Force -Confirm:$False
}

#Create Custom Associations XML File
$Encoding = [System.Text.Encoding]::UTF8
$Output_Custom_XML = New-Object System.XMl.XmlTextWriter($Custom_FileAssociations, $Encoding)

#Format XML Objects
$Output_Custom_XML.Formatting = 'Indented'
$Output_Custom_XML.Indentation = 1
$Output_Custom_XML.IndentChar = "`t"

#Create XML Elements
$Output_Custom_XML.WriteStartDocument()

#Create First XML Element
$Output_Custom_XML.WriteStartElement("DefaultAssociations")

#If Parameters passed, create a variable for the File Type
If ($Browser) { 

    #Get File Extension associations from Master Associations XML for the Browser Aplication Selected
    $Browser_Assocs = @($Associations_FileType.AssociationsXML.Browser.$Browser.DefaultAssociations.Association) 

    Foreach ($Browser_Assoc in $Browser_Assocs){

        #Create Association Element
        $Output_Custom_XML.WriteStartElement("Association")
        $Output_Custom_XML.WriteAttributeString("Identifier", $null, $Browser_Assoc.Identifier)
        $Output_Custom_XML.WriteAttributeString("ProgId", $null, $Browser_Assoc.ProgId)
        $Output_Custom_XML.WriteAttributeString("ApplicationName", $null, $Browser_Assoc.ApplicationName)

        #Close Association Elemment
        $Output_Custom_XML.WriteEndElement()
    }

}
If ($PDF) { 

    #Get File Extension associations from Master Associations XML for the PDF Application Selected
    $PDF_Assocs = @($Associations_FileType.AssociationsXML.PDF.$PDF.DefaultAssociations.Association) 

    Foreach ($PDF_Assoc in $PDF_Assocs) {

        #Create Association Element
        $Output_Custom_XML.WriteStartElement("Association")
        $Output_Custom_XML.WriteAttributeString("Identifier", $null, $PDF_Assoc.Identifier)
        $Output_Custom_XML.WriteAttributeString("ProgId", $null, $PDF_Assoc.ProgId)
        $Output_Custom_XML.WriteAttributeString("ApplicationName", $null, $PDF_Assoc.ApplicationName)

        #Close Association Elemment
        $Output_Custom_XML.WriteEndElement()
    }
}
If ($LOG) { 

    #Get File Extension associations from Master Associations XML for the LOG Application Selected
    $LOG_Assocs = @($Associations_FileType.AssociationsXML.LOG.$LOG.DefaultAssociations.Association) 

    Foreach ($LOG_Assoc in $LOG_Assocs) {

        #Create Association Element
        $Output_Custom_XML.WriteStartElement("Association")
        $Output_Custom_XML.WriteAttributeString("Identifier", $null, $LOG_Assoc.Identifier)
        $Output_Custom_XML.WriteAttributeString("ProgId", $null, $LOG_Assoc.ProgId)
        $Output_Custom_XML.WriteAttributeString("ApplicationName", $null, $LOG_Assoc.ApplicationName)

        #Close Association Elemment
        $Output_Custom_XML.WriteEndElement()
    }
}

#Close <AssociationsXML> 
$Output_Custom_XML.WriteEndElement()

#Close Custom Associations XML File
$Output_Custom_XML.WriteEndDocument()
$Output_Custom_XML.Flush()
$Output_Custom_XML.Close()