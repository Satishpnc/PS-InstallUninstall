
Param([parameter(Mandatory=$true,
   HelpMessage="Enter Notepad++ Version to Install")]
   $versionToInstall
, [parameter(Mandatory=$true,
   HelpMessage="Enter Network Location Path of notepad++")]
   $networkLocation)

###Write-Host "Installing Version of Notepad++ is: "$versionToInstall
####Write-Host "Installing from the Network Location Path is: " $networkLocation



If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   

  $arguments = "& '" + $myinvocation.mycommand.definition + "'"

  Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments

  break

}


Set-Location $PSScriptRoot


### Uninstall previous installation of Notepad++

Write-Host "Looking to see if Notepad++ is already installed..."

$notePadInstallations = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -match "Notepad++"}



if ($notePadInstallations)

{

  foreach ($notePadInstallation in $notePadInstallations) 

  {

     Write-Host "Found version" $notePadInstallation.Version



     if ($notePadInstallation.Version -ne $versionToInstall)

     {

         ## Kill NotePad++ if it's running

         Stop-Process -processname notePad -erroraction 'silentlycontinue'



         ## Install NotePad++

         Write-Host "Uninstalling notePad version " $notePadInstallation.Version

         if ($notePadInstallation.uninstall().returnvalue -eq 0) { write-host "Successfully uninstalled NotePad++" }

         else { write-warning "Failed to uninstall NotePad++" }



      }

      else

      {

         Write-Host "NotePad++" $versionToInstall " is already installed."

         return

      }   

   }

}

else

{ 

    Write-Host "No NotePad++ installation found"

}





## Installation Path

$appFolderDest = $networkLocation 
###"C:\Program Files (x86)\notePad\"



### Install New application

$appInstallerFilename = ".\notePadSetup_" + $versionToInstall + ".exe"

$appInstaller = Resolve-Path $appInstallerFilename

$logFile = $env:TEMP + "\notePad-install-" + $timestamp + ".log"

$commandLineOptions = "/qn /L*V `"$logFile`""

Write-Host "Installing notePad version:" $versionToInstall

Write-Host "with:" $appInstaller $commandLineOptions

Start-Process -Wait -FilePath $appInstaller -ArgumentList $commandLineOptions


Write-Host "notePad" $versionToInstall " has been installed."
