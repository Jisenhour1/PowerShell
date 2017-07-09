<#
.Synopsis
   Copies files from a single directory to target directory maintaining structure.
.DESCRIPTION
   Accepts Source, and target directory
.EXAMPLE
   Copy -Source c:\Example1 -Target C:\Exampe2
.INPUTS
   Source directory, and target directory.
.OUTPUTS
   With verbose switch success or failure of operation.  
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Copy-Directory (OptionalParameters) 
{
    Begin
        {
        }
        Process
        {
            if ($pscmdlet.ShouldProcess("Target", "Operation"))
            {
                $source = 'd:\t1'
                $dest = 'd:\t2'
                $exclude = @('web.config')
                $DirList = Get-ChildItem $source -Recurse -Exclude $exclude 
                $DirList| Copy-Item -Destination {Join-Path $dest $_.FullName.Substring($source.length)}
            }
        }
        End
        {
        }
    }  
}
