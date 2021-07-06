function get-blocks {
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipeline)]
        [string]$Message
    )

    begin {
        write-host "this is the first item" -foregroundcolor Blue
    }

    process {
        write-host "these are all the messages $($message)" -ForegroundColor Green
    }

    end {
        write-host "this is the last message" -ForegroundColor Red

    }

}