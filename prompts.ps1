
#Grabs user input from an available list of inputs
Function Get-UserInput{

    $Table = New-Object -TypeName System.Text.StringBuilder
    [void]$Table.AppendLine("...View Metrics Script...")
    [void]$Table.AppendLine("1. Output .log files")
    [void]$Table.AppendLine("2. List all files")
    [void]$Table.AppendLine("3. List CPU and memory usage")
    [void]$Table.AppendLine("4. List active running processes")
    [void]$Table.AppendLine("5. Exit Script")
    Write-Host -ForegroundColor Green $Table.ToString()
    return $(Read-Host -ForegroundColor Green "Enter a number between (1-5)")
}

try {
    $userInput = 1

    while ($userInput -ne 5) {
        $userInput = Get-UserInput

        switch ($userInput) {
            1 
            {
                #Creates a file called DailyLog.txt and appends all files with a log extension including date
                Get-Date | Out-File -FilePath "$PSScriptRoot\DailyLog.txt" -Append
                Get-ChildItem -Path $PSScriptRoot -Filter *.log | Out-File -FilePath "$PSScriptRoot\DailyLog.txt" -Append
            }
            
            2 
            {
                #Lists all files in the folder and outputs it in Contents.txt
                Get-ChildItem "$PSScriptRoot" | Sort-Object Name | Format-Table -AutoSize -Wrap | Out-File -FilePath "$PSScriptRoot\contents.txt"
            }
            
            3 
            {
                #Lists current processor and memory usage.
                Get-Counter -Counter "\Processor(_Total)\% Processor Time", "\Memory\Committed Bytes "
            }
            
            4 
            {
                #Lists current running proccesses sorted in alphabetical order and in a grid view
                Get-Process | Select-Object ID, Name, VM | Sort-Object Name | Out-GridView
            }
            
            5 
            {
                #Exits the script
                Write-Host -ForegroundColor Green "Goodbye"
            }
        }
    }
} catch [System.OutOfMemoryException]{
    #If system out of memory error triggers, outputs this message
    Write-Host -ForegroundColor Red "ERROR $_"
}