<#
.SYNOPSIS
    Looks under the given directory for files matching the given set of file signatures.

.DESCRIPTION
    Recurses through the given directory, and checks the primary data stream of
    all files for the specified file type signatures. The default signatures
    are RAR and ZIP, but others may be specified with the `filetypes` parameter.

.PARAMETER path
    The path to a directory to search.

.PARAMETER include
    A pattern for matching files to check (default: *.txt)

.PARAMETER filetypes
    An array of file type signatures. This is a hashtable array. Each hashtable
    must have `name` and `sig` members. The `name` is what is reported in the 
    result for matching files. The `sig` is a string which should be the first
    N-bytes of the given file (e.g. "PK" for a ZIP file or "Rar!" for a RAR
    file). The default file types supported are `RAR` and `ZIP`.

.OUTPUTS
    An array of PSObjects describing the files which matched a given signature.
    There are two properties in these objects:
        - Path: The full path to the file
        - Type: The matching name from the file type signature list

.NOTES
    Name: Get-MatchingFileTypes.ps1
    Author: Caleb Stewart
    DateCreated: 28JAN2019

.LINK
    https://github.com/Caleb1994/Get-MatchingFileTypes

.EXAMPLE
    .\Get-MatchingFileTypes -Path "C:\Users\Student\Documents\exercise_8"
    Find files which match a RAR or ZIP signature in the `exercise_8` directory.
#>
param(
    [Parameter(Mandatory=$true)][string]$path,
    [HashTable[]]$filetypes = @(
        @{
            name = "zip";
            sig = "PK";
        },
        @{
            name = "rar";
            sig = "Rar";
        }
    ),
    [string]$include = "*.txt"
)

# Grab a list of files to iterate over
$file_list = Get-ChildItem -Path $path -Include $include -Recurse -Force | Where-Object { ! $_.PSIsContainer }
# Iterator for progress
$iter = 0
# Result object
$result = @()

# Recursively iterate over all files that aren't directories
ForEach( $item in $file_list ) {
    # Post update for this file
    Write-Progress -Activity "Get-MatchingFileTypes" -Status "Checking $($item.FullName) against known file types" -PercentComplete (([float]$iter / $file_list.Length)*100.0)

    # Iterate through each file type
    ForEach( $type in $filetypes ){
        # Grab the data
        $data = [System.Text.Encoding]::ASCII.GetString($(Get-Content -Encoding byte $item.FullName )[0..($type["sig"].Length-1)])

        # Check if it matches (and add to results)
        if( $data -ceq $type["sig"] ){
            $result += New-Object -TypeName PSObject -Property @{
                path = $item.FullName;
                type = $type["name"];
            }
            break
        }
    }

    # Iterator for status updates
    $iter += 1
}

# Return results
return $result
