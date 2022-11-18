#Title : Windows Server features-Test Outcome #1.1
describe windows_feature ('Web-Server') do
 it { should be_installed }
end

describe windows_feature ('Web-Common-Http') do
 it { should be_installed }
end

describe windows_feature ('Web-Default-Doc') do
 it { should be_installed }
end

describe windows_feature ('Web-Dir-Browsing') do
 it { should be_installed }
end

describe windows_feature ('Web-Http-Errors') do
 it { should be_installed }
end

describe windows_feature ('Web-Static-Content') do
 it { should be_installed }
end

describe windows_feature ('Web-Health') do
 it { should be_installed }
end

describe windows_feature ('Web-Http-Logging') do
 it { should be_installed }
end

describe windows_feature ('Web-Custom-Logging') do
 it { should be_installed }
end

describe windows_feature ('Web-Log-Libraries') do
 it { should be_installed }
end

describe windows_feature ('web-odbc-logging') do
 it { should be_installed }
end


describe windows_feature ('Web-Request-Monitor') do
 it { should be_installed }
end

describe windows_feature ('Web-Http-Tracing') do
 it { should be_installed }
end 

describe windows_feature ('Web-Http-Tracing') do
 it { should be_installed }
end 

describe windows_feature ('web-performance') do
 it { should be_installed }
end 

describe windows_feature ('web-stat-compression') do
 it { should be_installed }
end 

describe windows_feature ('web-security') do
 it { should be_installed }
end 

describe windows_feature ('web-filtering') do
 it { should be_installed }
end 

describe windows_feature ('web-app-dev') do
 it { should be_installed }
end 

describe windows_feature ('Web-net-ext') do
 it { should be_installed }
end 

describe windows_feature ('web-net-ext45') do
 it { should be_installed }
end 

describe windows_feature ('web-asp-net45') do
 it { should be_installed }
end 

describe windows_feature ('web-isapi-ext') do
 it { should be_installed }
end 

describe windows_feature ('web-isapi-filter') do
 it { should be_installed }
end 

describe windows_feature ('web-mgmt-tools') do
 it { should be_installed }
end 

describe windows_feature ('web-mgmt-console') do
 it { should be_installed }
end 

describe windows_feature ('net-framework-features') do
 it { should be_installed }
end 

describe windows_feature ('net-framework-core') do
 it { should be_installed }
end 


describe windows_feature ('net-http-activation') do
 it { should be_installed }
end 


describe windows_feature ('net-framework-45-features') do
 it { should be_installed }
end 


describe windows_feature ('net-framework-45-core') do
 it { should be_installed }
end 


describe windows_feature ('net-framework-45-aspnet') do
 it { should be_installed }
end 



describe windows_feature ('NET-WCF-Services45') do
 it { should be_installed }
end

describe windows_feature ('net-wcf-http-activation45') do
 it { should be_installed }
end 


describe windows_feature ('net-wcf-tcp-portsharing45') do
 it { should be_installed }
end 

describe windows_feature ('Was') do
 it { should be_installed }
end 

describe windows_feature ('was-process-model') do
 it { should be_installed }
end 


describe windows_feature ('was-net-environment') do
 it { should be_installed }
end 


describe windows_feature ('was-config-apis') do
 it { should be_installed }
end 
 

#Title : Check desktop shortcut odbcad32 exists - Test Outcome #1.2

describe file('C:\Users\Public\Desktop\odbcad32.lnk') do
 it { should exist }
end
describe powershell("$Shortcuts = Get-ChildItem -Recurse 'C:\\Users\\Public\\Desktop\\' -Include odbcad32.lnk
    $Shell = New-Object -ComObject WScript.Shell
    foreach ($Shortcut in $Shortcuts)
    {
        $Properties = @{
                targetpath =  $shortcut.targetpath
        Target = $Shell.CreateShortcut($Shortcut).targetpath
        }
                 New-Object PSObject -Property $Properties
                 }") do
                 puts "Verifying the target path of shortcut"
                 its('stdout') { should include 'C:\Windows\SysWOW64\odbcad32.exe' }
end

#Title : Verifying the registry entry named 'ServicesPipeTimeout' - Test Outcome #1.3
describe registry_key({
  name: 'ServicesPipeTimeout',
  hive: 'HKEY_LOCAL_MACHINE',
  key: '\System\CurrentControlSet\Control'
 }) do
 it { should exist }
 its('ServicesPipeTimeout') { should eq 60000 }
end

#Title : Verify access control list permission for user account IIS_IUSRS - Test Outcome #1.4
describe directory('C:\Windows\Temp') do
    it { should exist }
    it { should be_allowed('modify', by_user: 'BUILTIN\\IIS_IUSRS') }
 end

#Title : Verifying the features related to the 'IIS Reset' windows task - Test Outcome #1.5a

#Description : Verifying the features related to the 'IIS Reset' windows task
describe windows_task('IIS Reset') do
   it { should exist }
  its('task_to_run') { should eq 'C:\\OBOL\\Utilities\\GCSServiceStartRestarter\\Application\\GCSServiceStartRestarter.exe IISRESET' }
  its('run_as_user') { should eq 'SYSTEM' }
end

#Verifying the Trigger of 'IIS Reset' windows task
describe powershell("Get-ScheduledTaskInfo 'IIS Reset' | Select NextRunTime") do
puts "Verifying if the Next Run Time of 'IIS Reset' is '2:00:30 AM'"
its('strip') { should include '2:00:00 AM' }
end

#Verifying the trigger of 'IIS Reset' windows task is Daily
describe powershell("Get-ScheduledTask -TaskName 'IIS Reset' -Verbose | select Triggers") do
puts "Verifying the trigger of 'IIS Reset' windows task is Daily"
its('strip') { should include 'MSFT_TaskDailyTrigger' }
end

#Title : Verifying the features related to the 'Service Restart' windows task - Test Outcome #1.5b
describe windows_task('Service Restart') do
   it { should exist }
  its('task_to_run') { should eq 'C:\\OBOL\\Utilities\\GCSServiceStartRestarter\\Application\\GCSServiceStartRestarter.exe Restart' }
  its('run_as_user') { should eq 'SYSTEM' }
end

#Verifying the Trigger of 'Service Restart' windows task
describe powershell("Get-ScheduledTaskInfo 'Service Restart' | Select NextRunTime") do
puts "Verifying if the Next Run Time of 'Service Restart' is '2:30:30 AM'"
its('strip') { should include '2:30:30 AM' }
end

#Verifying the trigger of 'Service Restart' windows task is Daily
describe powershell("Get-ScheduledTask -TaskName 'Service Restart' -Verbose | select Triggers") do
puts "Verifying the trigger of 'Service Restart' windows task is Daily"
its('strip') { should include 'MSFT_TaskDailyTrigger' }
end

#Title : Verifying the features related to the 'Service Monitor' windows task - Test Outcome #1.5c
describe windows_task('Service Monitor') do
   it { should exist }
  its('task_to_run') { should eq 'C:\\OBOL\\Utilities\\GCSServiceStartRestarter\\Application\\GCSServiceStartRestarter.exe Start' }
  its('run_as_user') { should eq 'SYSTEM' }
end

#Verifying the Repetition Trigger of 'Service Monitor' windows task
describe powershell("$task = Get-ScheduledTask -TaskName 'Service Monitor'
$task.Triggers[0].Repetition | select -ExpandProperty interval") do
 puts "Verifying the Repetition Trigger of 'Service Monitor' windows task"
  its('strip') { should eq 'PT5M' }
end

#Verifying the Boot up Time Trigger of 'Service Monitor' windows task
describe powershell("Get-ScheduledTask -TaskName 'Service Monitor' -Verbose | select Triggers ") do
 puts "Verifying the Boot up Time Trigger of 'Service Monitor' windows task"
its('strip') {should include "MSFT_TaskBootTrigger"}
end

#Title : Verifying the features related to the ' OBOL_Recursive_Delete' windows task - Test Outcome #1.5d
describe windows_task('OBOL_Recursive_Delete') do
   it { should exist }
  its('task_to_run') { should eq 'C:\OBOL\Utilities\OBOL_Recursive_Delete\OBOL_Recursive_Delete.bat' }
  its('run_as_user') { should eq 'SYSTEM' }
end

#Title : Verifying if the file exists and it's contents - Test Outcome #1.6
describe file('C:\OBOL\Utilities\OBOL_Recursive_Delete\obol_recursive_delete.bat') do
 it { should exist }
 its(:content) { should include 'OBOL_Recursive_Delete.exe /rootdirectory:"M:\Logs" /fileage:7' }
end

#Title : Verifying if '.Net 3.1' is installed - Test Outcome #2
describe package('Microsoft .NET Core Runtime - 3.1.3 (x64)') do
 it { should be_installed }
end

#Title : Verifying if '.Net 6' is installed - Test Outcome #3
describe package('Microsoft .NET Runtime - 6.0.7 (x64)') do
 it { should be_installed }
end











#Title : Verifying if 'ODBC Driver 17' is installed - Test Outcome #5
describe package('Microsoft ODBC Driver 17 for SQL Server') do
 it { should be_installed }
end

#Title : Verifying if 'VC64' is installed - Test Outcome #6
describe package('*Microsoft Visual C++ *2010 *64 Redistributable - 10.0.30319') do
 it { should be_installed }
end

#Title : Verifying if 'VC86' is installed - Test Outcome #7
describe package('*Microsoft Visual C++ *2010 *86 Redistributable - 10.0.30319') do
 it { should be_installed }
end

#Title : Verifying if Octopus Deploy Tentacle is installed #8
describe package('Octopus Deploy Tentacle') do
 it { should be_installed }
end



#describe package('Microsoft ASP.NET core 6.0.7 - Shared Framework (x64)') do
# it { should be_installed }
#end

describe package('Microsoft .NET Core Runtime - 2.1.25 (x64)') do
 it { should be_installed }
end

describe package('Microsoft .NET Core Runtime - 3.1.3 (x64)') do
 it { should be_installed }
end

describe package('Microsoft .NET Runtime - 6.0.7 (x64)') do
 it { should be_installed }
end


describe package('Microsoft ODBC Driver 17 for SQL Server') do
 it { should be_installed }
end

describe package('*Microsoft Visual C++ 2012 Redistributable (x64)*') do
 it { should be_installed }
end

describe package('*Microsoft Visual C++ 2010 *64 Redistributable - 10.0.30319') do
 it { should be_installed }
end

describe package('*Microsoft Visual C++ 2010 *86 Redistributable - 10.0.30319') do
 it { should be_installed }
end

describe package('Octopus Deploy Tentacle') do
 it { should be_installed }
end








