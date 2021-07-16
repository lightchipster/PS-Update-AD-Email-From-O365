$rootPath = (Get-Item $PSScriptRoot).FullName
$office365users = Import-Csv -Delimiter "," -Path ($rootPath + "\O365Users.csv")



foreach($user in $office365users){
    # Find user
    $ADUser = Get-ADUser -Filter "displayname -eq '$($user.dname)'"
    if ($ADUser){
     # <update the user>
     Set-ADUser -Identity $ADUser -EmailAddress $user.emails
    }else{
        Write-Warning ("Failed to update " + $($user.dname))
    }
}
