If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   

  $arguments = "& '" + $myinvocation.mycommand.definition + "'"

  Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments

  break

}



Set-Location $PSScriptRoot



## There can be many places where notepad could have been installed.  Check likely places.

### List of likely places where notepad could be 

$possibleInstalledPaths = @("C:\Program Files\notepad\", "C:\Program Files (x64)\notepad\", "c:\notepad\")



$foundAnInstallation = $false

### For all places where notepad "could" be.

foreach ($installPath in $possibleInstalledPaths)

{

    

    ### If the path where notepad could be exists

    if (Test-Path($installPath))

    {



        ## Some notepad stuff might be running.. kill them.

        Stop-Process -processname notepad -erroraction 'silentlycontinue'

        Stop-Process -processname notepad* -erroraction 'silentlycontinue'



        $foundAnInstallation = $true

        Write-Host "Removing notepad++ from " $installPath



        ### Find if there's an uninstaller in the folder.

        $uninstallers = Get-ChildItem $installPath"\unins*.exe"



        ### In reality, there should only be just one that matches.

        foreach ($uninstaller in $uninstallers)

        {

           ### Invoke the uninstaller.

           $uninstallerCommandLineOptions = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /FORCECLOSEAPPLICATIONS"

           Start-Process -Wait -FilePath $uninstaller -ArgumentList $uninstallerCommandLineOptions

        }



        ### Remove the folder if it didn't clean up properly.

        if (Test-Path($installPath))

        {

           Remove-Item -Recurse -Force $installPath

        }

    }

}



if (!($foundAnInstallation))

{

   Write-Host "No notepad++ installation found. Nothing to uninstall"

}
