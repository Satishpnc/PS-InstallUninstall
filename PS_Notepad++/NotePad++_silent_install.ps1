
$message  = 'Starting Install/Update/Uninstall of Notepad++ operation'
$question = 'If you wish to continue this operation, Press the below options:'

$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Install'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&NewVersionUpdate'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Uninstall'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Exit'))

$decision = $Host.UI.PromptForChoice($message, $question, $choices,3)
if ($decision -eq 0) {
	$notepadInstallScript = Resolve-Path ".\task_install-updateNewerVersion_notepad++_silent.ps1"
  if (Test-Path $notepadInstallScript)
   {
       &"$notepadInstallScript"
   }
} elseif ($decision -eq 1) {
  $notepadUpdateScript = Resolve-Path ".\task_install-updateNewerVersion_notepad++_silent.ps1"
  if (Test-Path $notepadUpdateScript)
   {
       &"$notepadUpdateScript"
   }
} elseif ($decision -eq 2) {
  $notepadUinstallScript = Resolve-Path ".\task_uninstall_notepad++_silent.ps1"
  if (Test-Path $notepadUinstallScript)
   {
       &"$notepadUinstallScript"
   }
} elseif ($decision -eq 3) {
  Write-Host "Exiting the operation."
  Exit
}