function Copy-WithProgress {
    <#
        .SYNOPSIS
            Copy a file with progress indication.
        .DESCRIPTION
            This function copies a file from one location to another, displaying a progress bar during the copy process.
        .PARAMETER from
            The source file path.
        .PARAMETER to
            The destination file path.
        .EXAMPLE
            Copy-WithProgress -from "C:\source\file.txt" -to "C:\destination\file.txt"
    #>
    [CmdletBinding()]
    [OutputType([void])]
param( [string]$from, [string]$to)
    $ffile = [io.file]::OpenRead($from)
    $tofile = [io.file]::OpenWrite($to)
    Write-Progress -Activity "Copying file" -status "$from -> $to" -PercentComplete 0
    try {
        [byte[]]$buff = new-object byte[] 4096
        [long]$total = [int]$count = 0
        do {
            $count = $ffile.Read($buff, 0, $buff.Length)
            $tofile.Write($buff, 0, $count)
            $total += $count
            if ($total % 1mb -eq 0) {
                Write-Progress -Activity "Copying file" -status "$from -> $to" `
                   -PercentComplete ([long]($total * 100 / $ffile.Length))
            }
        } while ($count -gt 0)
    }
    finally {
        $ffile.Dispose()
        $tofile.Dispose()
        Write-Progress -Activity "Copying file" -Status "Ready" -Completed
    }
}