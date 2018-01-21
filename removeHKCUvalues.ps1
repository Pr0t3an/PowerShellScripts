$regkeyarrays = 'Str3','Str2','str1'
$staging = 'hklm\temphives\'
$regkeypath= 'HKLM:\temphives\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
Write-Host "Searching for the following Run Keys: $regkeyarrays"
#set key path
$localPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
$realuser = $env:UserName


# $users = (Get-ChildItem -path c:\users).name
$users = get-childitem 'c:\users' -name
Start-Sleep -Seconds 3

foreach($user in $users)
	{
   
    
		If($realuser -eq $user) 	
		{
             foreach($regkeyarray in $regkeyarrays){
   			 $value1 = Get-ItemProperty $localPath $regkeyarray -EA SilentlyContinue
   			 if ($value1 -eq $null) { Write-Host "nothing to see" }
   			 else {Get-Item -Path $localPath | Remove-ItemProperty -Name $regkeyarray -force -EA SilentlyContinue
             write-host "Found & Removed for $user : $regkeyarray"} 
			}
            }
        else
        {
       
        $new1 = "c:\users\$user\ntuser.dat"
        write-host $new1
        reg load $staging $new1
        Start-Sleep -Seconds 5
        # cd hklm:\temphive\software
        foreach($regkeyarray in $regkeyarrays){
        $value1 = Get-ItemProperty $regkeypath $regkeyarray -EA SilentlyContinue
   	    if ($value1 -eq $null) { Write-Host "nothing to see" }
   		else {$result = Get-Item -Path $regkeypath | Remove-ItemProperty -Name $regkeyarray -force -EA SilentlyContinue
              $result.Handle.Close()
             write-host "Found & Removed for $user : $regkeyarray"}
             
        
        }
        Start-Sleep -Seconds 5
        [gc]::Collect()	
		[gc]::WaitForPendingFinalizers()
        Start-Sleep -Seconds 5
        reg unload $staging
        [gc]::Collect()	
		[gc]::WaitForPendingFinalizers()
        start-sleep -seconds 5
        
        
        }	
	}
    
