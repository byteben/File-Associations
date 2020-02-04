# File-Associations
  
**Contents**
 
 - Set-FileAssoc.ps1
 - Associations_Master.xml
  

# DESCRIPTION
  
Welcome to the File Associations Repository. The purpse of this project is to create a Default File Associations file for use with DISM or GPO to set the Default File Associations in Windows 10 for new users.

# Contribute
  
All ideas for applications and file types to include in this project are welcome

# Current Default Apps Considered in the Project
  
**Browser**
 - Chrome
 - Edge
 - Firefox
 - IE
 
 **PDF**
 - AcrobtDC
 - Edge
 - ReaderDC
 
 **LOG**
 - CMTrace
 - Notepad
 
# Associations_Master.xml

The Master XML file uses elements to distunguish between the various applications and filetypes. If you are confident with XML structures, it is ok to modify this file. You will need to update the Parameter Validation Sets in the **Set-FileAssoc.ps1** file to reflect the XML changes.
