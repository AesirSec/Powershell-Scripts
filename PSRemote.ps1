powershell.exe -NoExit -Command {Invoke-Command -ScriptBlock {
$Cred = Get-Credential
Add-Type -AssemblyName Microsoft.VisualBasic
$computer = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a computer name", "Computer")
$session = Enter-PSSession -ComputerName $computer -Credential $Cred}}