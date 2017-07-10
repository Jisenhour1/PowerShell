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

        [Parameter()]
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
    PROCESS {
        Write-Verbose "HERE WE GO!!!!"
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
    END {
        if ($ErrorsHappened) {
            Write-Warning "OMG, errors. Logged to $ErrorLogFilePath."
        }
    }
}
