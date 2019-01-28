# Get-MatchingFileTypes - Look for files matching the given signatures

This script will recursively scan a given directory for files which match the given file signatures. By default, the script will look for `*.txt` files matching the signatures of `ZIP` or `RAR` files.

## Default Search 

To search for `.txt` files matching a `ZIP` or `RAR` signature, you can scan a given directory with:

```powershell
PS C:\Users\Student\Documents\exercise_8> .\Get-MatchingFileTypes.ps1 -Path ".\" | Format-Table Path,Type

Path                                                                                      Type
----                                                                                      ----
C:\Users\Student\Documents\exercise_8\bqekifltpz\jodwsxfrti\nwxyjdohvp\aqurtjhsxp.txt     rar 
[... removed for brevity ...]
C:\Users\Student\Documents\exercise_8\sgtcpqbwzo\aqigjmtcbv\zydbtpfcul.txt                zip 
```

## Customized file name matching

To search for files other than `.txt` files, you can use the `-Include` parameter, as seen below:

```powershell
PS C:\Users\Student\Documents\exercise_8> .\Get-MatchingFileTypes.ps1 -Path ".\" -Include "*.rar" | Format-Table Path,Type

Path                                                                                      Type
----                                                                                      ----
C:\Users\Student\Documents\exercise_8\bqekifltpz\jodwsxfrti\nwxyjdohvp\aqurtjhsxp.txt     rar 
[... removed for brevity ...]
```

## Customized file signatures

You can pass an array of hashtables which specify different file type signatures to look for using the `filetype` parameter. This will replace the default, so you must explicitly specify the `ZIP` or `RAR` types if you want them for your custom search. For example, to search for `GIF` files with any name, you could do the following:

```powershell
PS C:\Users\Student\Documents\exercise_8> $signatures = @(
  @{ name = "GIF87"; sig = "GIF87a"; },
  @{ name = "GIF89"; sig = "GIF89a"; }
)
PS C:\Users\Student\Documents\exercise_8> .\Get-MatchingFileTypes.ps1 -Path ".\" -Include "*" -FileTypes $signatures | Format-Table Path,Type
```

# Continued Development and/or Support

This project was created to satisfy an exercise in a course for work, and to assist fellow students. It's probably not that useful to anyone, and I will not be continuing development. If you like it, feel free to fork it, or message me. However, I don't plan on supporting it further. Thanks for reading!
