<#
.Synopsis
   Uninstalls an application from the machine
.DESCRIPTION
   Designed to accept app name as a parameter and uninstall the app
.EXAMPLE
   Remove-Application <Name of application>
.INPUTS
   Software Nane
.OUTPUTS
   None 
#>

$Logfile = "C:\error.txt"
function Remove-Application
{
    [CmdletBinding(SupportsShouldProcess = $True,ConfirmImpact = 'High')]

    param
    (
        [Parameter(Mandatory=$True,
                   HelpMessage="Name of software to be removed")]
        [string] $SoftwareName,

        [Parameter(HelpMessage = "Path to error log")]
        [string]$ErrorLogFilePath = $Logfile
    )
    $ErrorsHappened = $False
    Remove-Item -Path $ErrorLogFilePath -Force -ErrorAction SilentlyContinue
    if($PSCmdlet.ShouldProcess("Uninstalling $SoftwareName"))
    {
        $app = Get-WmiObject -Class Win32_Product `
                     -Filter "Name = $SoftwareName"
        If($app -ne $null)
        {
            Write-Verbose "Uninstalling $SoftwareName"
            $app.Uninstall()
        }
        Else
        {
            $ErrorsHappened = $True
            "Application $SoftWare not found"| Out-File $ErrorLogFilePath -Append
         }
    }

}