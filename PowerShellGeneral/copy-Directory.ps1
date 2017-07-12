<#
.Synopsis
   Copies files from a single directory to target directory maintaining structure.
.DESCRIPTION
   Designed to accept source directory as a string, and target directoies as an array and duplicate source structure on each of the target directoies.
.EXAMPLE
   (Get-ChildItem -Recurse -Depth 1 -Directory).FullName | Copy-Directory -SourceDirectory C:\Source
.INPUTS
   Source directory, target directory, and exclude file, or pattern.
.OUTPUTS
   With verbose switch success or failure of operation. c 
#>

$Logfile = "C:\error.txt"
function Copy-Directory 
{
    [CmdletBinding(SupportsShouldProcess = $True,ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory=$True,
            HelpMessage="The full path to source directory")]
        [Alias('source')]
        [string] $SourceDirectory,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="The full path to the base directory")]
        [Alias('Target')]
        [string[]]$TargetDirectory,

        [Parameter(Mandatory=$False,
                HelpMessage="File name. or pattern to exlude from copy operation")]
        [string]$Exlude,

        [Parameter(HelpMessage = "Path to error log")]
        [string]$ErrorLogFilePath = $Logfile
    )
    BEGIN 
    {
        
        $ErrorsHappened = $False
        Remove-Item -Path $ErrorLogFilePath -Force -ErrorAction SilentlyContinue
        if (!(Test-Path $SourceDirectory ))
        {
            Write-Verbose "$SourceDirectory not found"
            "Source $SourceDirectory not found"| Out-File $ErrorLogFilePath -Append
            $ErrorsHappened = $True
        }  
        if($ErrorsHappened) 
        {
            Break
        }    
        $ErrorsHappened = $False
    }
    PROCESS 
    {
        Write-Verbose "HERE WE GO!!!!"
        if($PSCmdlet.ShouldProcess("Copy from $SourceDirectory to $TargetDirectory"))
        {  
          
        
            foreach ($Directory in $TargetDirectory)
            {
                try 
                {   

                    Write-Verbose "------------------------------"
                    Write-Verbose "Starting to cop to $TargetDirectory"
                    if ((Test-Path $TargetDirectory ))
                    {
                        $DirList = Get-ChildItem $SourceDirectory -Recurse -Exclude $exclude 
                        $DirList| Copy-Item -Destination {Join-Path $TargetDirectory $_.FullName.Substring($SourceDirectory.length)}    
                    }   
                    Else
                    {
                         Write-Verbose "$TargetDirectory not found"
                        "Target $TargetDirectory not found"| Out-File $ErrorLogFilePath -Append
                        $ErrorsHappened = $True
                    }
                
                

                } 
                catch 
                {

                    Write-Verbose "Couldn't vopy to $TargetDirectory"
                    "Failed to copy to $TargetDirectory" | Out-File $ErrorLogFilePath -Append
                    $ErrorsHappened = $True
                } 
            }
        }
    }
    END 
    {
        if ($ErrorsHappened) 
        {
            Write-Warning "Errors Logged to $ErrorLogFilePath."
        }
    }
}
