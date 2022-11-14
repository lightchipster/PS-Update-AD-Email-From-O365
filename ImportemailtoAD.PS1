$rootPath = (Get-Item $PSScriptRoot).FullName
$office365users = Import-Csv -Delimiter "," -Path ($rootPath + "\O365Users.csv")
$UsersArray = @()


foreach($user in $office365users){
    # Find user
    $ADUser = Get-ADUser -Filter "displayname -eq '$($user.dname)'"
    if ($ADUser){
     # <update the user>
     Set-ADUser -Identity $ADUser -EmailAddress $user.emails
    }else{
        #Creates error if unable to find a match between AD and Office 365 display name
        Write-Warning ("Failed to update " + $($user.dname))
        #Creates an array of the users that don't match
        $myobj = "" | Select "display", "email", "firname", "laname"
        $myobj.display = $user.dname
        $myobj.email = $user.emails
        $myobj.firname = $user.fname
        $myobj.laname = $user.lname

        $UsersArray += $myobj
        $myobj = $null  
    }
}

#Outputs the failures to CSV
$UsersArray | export-csv "ImportFailures.csv"
