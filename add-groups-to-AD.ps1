###########################
# Create a bunch of groups programtically in AD from CSV
###########################
# 2016-05-03 by John Lucas
#
# Based on http://pipe2text.com/?page_id=2334
#

#Import-Module ActiveDirectory
#$groups = Import-Csv ‘c:\scripts\groups.csv‘
#foreach ($group in $groups) {
#New-ADGroup -Name $group.name -Path “OU=OUWhereIStoreMyGroups,DC=Pipe2Text,DC=com” -Description “New Groups Created in Bulk” -GroupCategory Security -GroupScope Universal -Managedby BC
#}

#############################################################################
##    Begin script elevation code
# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
 
$MyOrigBackColor = $Host.UI.RawUI.BackgroundColor
# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   # For colors, see: http://windowsitpro.com/powershell/take-control-powershell-consoles-colors
   $Host.UI.RawUI.BackgroundColor = "DarkRed"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator
   
   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);
   
   # Exit from the current, unelevated, process
   exit
   }
 
# Run your code that needs to be elevated here
#Write-Host -NoNewLine "Press any key to continue..."
#$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

##    End script elevation code
#############################################################################


Import-Module ActiveDirectory
$groups = Import-Csv 'c:\scripts\add-groups-to-AD.csv'
foreach ($group in $groups) {
  New-ADGroup -Name $group.name -Path "OU=Facility specific permissions,OU=User Groups,DC=example,DC=local" -Description "Created to give directors access to resources" -GroupCategory Security -GroupScope Global
}

Write-Host -NoNewLine "End of script....Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
