# Title : Test Outcome #1a
# Description: Verifying if the odbcad32 shortcut exists

describe file('C:\Users\Public\Desktop\odbcad32.lnk') do
  it { should exist }
end

# Title : Test Outcome #1a
# Description: Verifying the target path of shortcut

describe powershell("$Shortcuts = Get-ChildItem -Recurse 'C:\\Users\\Public\\Desktop\\' -Include odbcad32.lnk
    $Shell = New-Object -ComObject WScript.Shell
    foreach ($Shortcut in $Shortcuts)
    {
        $Properties = @{
        ShortcutName = $Shortcut.Name;
        ShortcutFull = $Shortcut.FullName;
        ShortcutPath = $shortcut.DirectoryName
                targetpath =  $shortcut.targetpath
        Target = $Shell.CreateShortcut($Shortcut).targetpath
        }
                 New-Object PSObject -Property $Properties
                 }") do
  puts 'Verifying the target path of shortcut'
  its('stdout') { should include 'Target       : C:\Windows\SysWOW64\odbcad32.exe' }
end

# Title : Test Outcome #2
# Description : Verifying the registry entry named 'ServicesPipeTimeout'

describe registry_key({
                        name: 'ServicesPipeTimeout',
                        hive: 'HKEY_LOCAL_MACHINE',
                        key: '\System\CurrentControlSet\Control'
                      }) do
  it { should exist }
  its('ServicesPipeTimeout') { should eq 60_000 }
end

# Title : Test Outcome #3a
# Description : Verifying the features related to the 'Service Restart' windows task

describe windows_task('Service Restart') do
  it { should exist }
  its('task_to_run') do
    should eq 'C:\\OBOL\\Utilities\\GCSServiceStartRestarter\\Application\\GCSServiceStartRestarter.exe Restart'
  end
  its('run_as_user') { should eq 'SYSTEM' }
end

# Verifying the Trigger of 'Service Restart' windows task

describe powershell("Get-ScheduledTaskInfo 'Service Restart' | Select NextRunTime") do
  puts "Verifying if the Next Run Time of 'Service Restart' is '2:30:30 AM'"
  its('strip') { should include '2:30:30 AM' }
end

# Verifying the trigger of 'Service Restart' windows task is Daily

describe powershell("Get-ScheduledTask -TaskName 'Service Restart' -Verbose | select Triggers") do
  puts "Verifying the trigger of 'Service Restart' windows task is Daily"
  its('strip') { should include 'MSFT_TaskDailyTrigger' }
end

# Title : Test Outcome #3b
# Description : Verifying the features related to the 'Service Monitor' windows task

describe windows_task('Service Monitor') do
  it { should exist }
  its('task_to_run') do
    should eq 'C:\\OBOL\\Utilities\\GCSServiceStartRestarter\\Application\\GCSServiceStartRestarter.exe Start'
  end
  its('run_as_user') { should eq 'SYSTEM' }
  # its('start_time') { should eq '14:30' }
end

# Verifying the Repetition Trigger of 'Service Monitor' windows task

describe powershell("$task = Get-ScheduledTask -TaskName 'Service Monitor'
$task.Triggers[0].Repetition | select -ExpandProperty interval") do
  puts "Verifying the Repetition Trigger of 'Service Monitor' windows task"
  its('strip') { should eq 'PT5M' }
end

# Verifying the Boot up Time Trigger of 'Service Monitor' windows task

describe powershell("Get-ScheduledTask -TaskName 'Service Monitor' -Verbose | select Triggers ") do
  puts "Verifying the Boot up Time Trigger of 'Service Monitor' windows task"
  its('strip') { should include 'MSFT_TaskBootTrigger' }
end

# Title : Test Outcome #3c
# Description : Verifying the features related to the ' OBOL_Recursive_Delete' windows task

describe windows_task('OBOL_Recursive_Delete') do
  it { should exist }
  its('task_to_run') { should eq 'C:\OBOL\Utilities\OBOL_Recursive_Delete\OBOL_Recursive_Delete.bat' }
  its('run_as_user') { should eq 'SYSTEM' }
end

# Description : Verifying the Trigger of ' OBOL_Recursive_Delete' windows task

describe powershell("$task = Get-ScheduledTask -TaskName 'OBOL_Recursive_Delete'
$task.Triggers[0].Repetition | select -ExpandProperty interval") do
  puts "Verifying the Trigger of 'OBOL_Recursive_Delete' windows task"
  its('strip') { should eq 'PT5M' }
end

# Title : Test Outcome #4
# Description : Verifying if the file exists and it's contents

describe file('C:\OBOL\Utilities\OBOL_Recursive_Delete\obol_recursive_delete.bat') do
  it { should exist }
  its('content') { should include 'OBOL_Recursive_Delete.exe /rootdirectory:"M:\Logs" /fileage:30' }
end

# Title : Verifying if 'ODBC Driver 17' is installed

describe package('Microsoft ODBC Driver 17 for SQL Server') do
  it { should be_installed }
end

# Title : Verifying if 'Octo Tentacle' is installed

describe package('Octopus Deploy Tentacle') do
  it { should be_installed }
end
