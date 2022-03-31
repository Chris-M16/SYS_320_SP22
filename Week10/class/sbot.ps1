# Send an email using powershell

$toSend = @('christopher.mchugh@mymail.champlain.edu','chris.mchugh@mymail.champlain.edu','topher.mchugh@mymail.champlain.edu')

# Message body
$msg= "Hello"

while ($true) {
    foreach ($email in $toSend) {
        
        # Send the email
        write-host "Send-MailMessage -from 'christopher.mchugh@mymail.champlain.edu' -To $email -Subject 'Tisk Tisk' `
        -Body $msg -SmtpServer X.X.X.X"

        # Pause for 1 second
        Start-Sleep 1
    }
}