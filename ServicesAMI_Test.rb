
#Title : Test Outcome #1
#Description : Verifying if the odbcad32 shortcut exists
describe file('C:\Users\Public\Desktop\odbcad32.lnk') do
 it { should exist }
end

#Title : Test Outcome #1
#Description : Verifying the target path of shortcut exists
describe command("$Shortcuts = Get-ChildItem -Recurse 'C:\\Users\\Public\\Desktop\\' -Include odbcad32.lnk") do
output = `powershell.exe  #{"$Shortcuts = Get-ChildItem -Recurse 'C:\\Users\\Public\\Desktop\\' -Include odbcad32.lnk
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
                 }"}`
 puts output
 output.to_enum(:scan, /(Target)(.*)/i).map do |m,|
  Target= output[($`.size+15),(32)]
  puts "Target is "
  puts Target
  end
   describe "Verifying the Target path " do

                it "of the shortcut" do
                expect(Target).to eq 'C:\\Windows\\SysWOW64\\odbcad32.exe'
                end
        end
end

#Title : Test Outcome #2
#Description : Verifying the registry entry named 'ServicesPipeTimeout'
describe registry_key({
  name: 'ServicesPipeTimeout',
  hive: 'HKEY_LOCAL_MACHINE',
  key: '\System\CurrentControlSet\Control'
 }) do
 it { should exist }
 its('ServicesPipeTimeout') { should eq 60000 }
end

#Title : Test Outcome #3a
#Description : Verifying the features related to the 'Service Restart' windows task
describe windows_task('Service Restart') do
   it { should exist }
  its('task_to_run') { should eq 'C:\\OBOL\\Utilities\\GCSServiceStartRestarter\\Application\\GCSServiceStartRestarter.exe Restart' }
  its('run_as_user') { should eq 'SYSTEM' }
end

#Verifying the Trigger of "Service Restart' windows task

describe command("Get-ScheduledTaskInfo 'Service Restart'") do
output = `powershell.exe  #{"Get-ScheduledTaskInfo 'Service Restart'"}`
 output.to_enum(:scan, /(LastRunTime)(.*)/i).map do |m,|
#puts $` .size
  end
   output.to_enum(:scan, /(NextRunTime)(.*)/i).map do |m,|
  Restart_NextRunDate = output[($`.size+21),(11)]
  Restart_NextRunTime = output[($`.size+31),(11)]
  end
  describe "Verifying if the Next Run Time" do

                it "is 2:30:30 AM" do
                puts "Printing NextRunTime: "
                puts Restart_NextRunTime
                #expect(NextRunTime).to eq "2:30:30 AM"
                expect(Restart_NextRunTime).to include ("2:30:30 AM")
                end
        end
end
#Verifying the trigger of "Service Restart' windows task is Daily
describe command("Get-ScheduledTask -TaskName 'Service Restart' \" -Verbose | select Triggers \"") do
it { should exist }
Restart_Trigger_output = `powershell.exe #{"Get-ScheduledTask -TaskName 'Service Restart' \" -Verbose | select Triggers \""}`

describe "Verifying if the frequency Trigger" do

                it "is daily" do
                puts "Printing Trigger_output: "
                puts Restart_Trigger_output
                expect(Restart_Trigger_output).to include ("MSFT_TaskDailyTrigger")
                end
        end
puts "Powershell command has the string 'MSFT_TaskDailyTrigger'"
end

#Verifcying the description of "Service Restart' windows task
describe command("Get-ScheduledTask -TaskName 'Service Restart' \" -Verbose | select description \"") do
output = `powershell.exe #{"Get-ScheduledTask -TaskName 'Service Restart' \"-Verbose | select description \""}`

puts output
if(output.include?("Performs Windows service restarts"))

puts "Powershell command has the string 'Windows service restarts'"

output.to_enum(:scan,/(Performs)(.*)/i).map do |m,|
#puts ($` .size)
  Restart_Description = output[($`.size),(120)]
  end

  describe "Verifying if the Description" do

                it "is as expected for Service Restart" do
                puts "Printing Description: "
                puts Restart_Description
                expect("Performs Windows service restarts of the defined list of WIndows services that require a forced stop. This would include
Hyland Core Distribution and Workflow along with Thick Client workflow services.").to include (Restart_Description)
                end
        end

else
 specify "this test fails" do
  raise "because the description does not include the text 'Windows service restarts'"
end
end
end


#Title : Test Outcome #3b
#Description : Verifying the features related to the 'Service Monitor' windows task
describe windows_task('Service Monitor') do
   it { should exist }
  its('task_to_run') { should eq 'C:\\OBOL\\Utilities\\GCSServiceStartRestarter\\Application\\GCSServiceStartRestarter.exe Start' }
  its('run_as_user') { should eq 'SYSTEM' }
  #its('start_time') { should eq '14:30' }
end

#Verifying the Repetition Trigger of "Service Monitor' windows task
describe powershell("$task = Get-ScheduledTask -TaskName 'Service Monitor'
$task.Triggers[0].Repetition | select -ExpandProperty interval") do
  its('strip') { should eq 'PT5M' }
end

#Verifying the Boot up Time Trigger of "Service Monitor' windows task
describe command("Get-ScheduledTask -TaskName 'Service Monitor' \" -Verbose | select Triggers \"") do
it { should exist }
Trigger_output = `powershell.exe #{"Get-ScheduledTask -TaskName 'Service Monitor' \" -Verbose | select Triggers \""}`


describe "Verifying if the Trigger" do

                it "is as expected for MSFT_TaskBootTrigger" do
                puts "Printing Trigger_output: "
                puts Trigger_output
                expect(Trigger_output).to include ("MSFT_TaskBootTrigger")
                end
        end

puts "Powershell command has the string 'MSFT_TaskBootTrigger'"


end

#Verifying the Description of "Service Monitor' windows task
describe command("Get-ScheduledTask -TaskName 'Service Monitor' \" -Verbose | select description \"") do
output = `powershell.exe #{"Get-ScheduledTask -TaskName 'Service Monitor' \"-Verbose | select description \""}`

puts output
if(output.include?("Monitors"))

puts "Powershell command has the string 'Monitors'"

output.to_enum(:scan,/(Monitors)(.*)/i).map do |m,|
#puts ($` .size)
  Monitor_Description= output[($`.size),(110)]
  end

  describe "Verifying if the Description" do

                it "is as expected for Service Monitor" do
                puts "Printing Description: "
                puts Monitor_Description
                expect("Monitors the defined list of Windows services to ensure that they are running. Please see the wiki for more information."
).to include (Monitor_Description)
                end
        end

else
 specify "this test fails" do
  raise "because the description does not include the text 'Monitors'"
end
end
end

#Title : Test Outcome #3c
#Description : Verifying the features related to the ' OBOL_Recursive_Delete' windows task
describe windows_task('OBOL_Recursive_Delete') do
   it { should exist }
  its('task_to_run') { should eq 'C:\OBOL\Utilities\OBOL_Recursive_Delete\OBOL_Recursive_Delete.bat' }
  its('run_as_user') { should eq 'SYSTEM' }
end

#Description : Verifying the Trigger of ' OBOL_Recursive_Delete' windows task
describe powershell("$task = Get-ScheduledTask -TaskName 'OBOL_Recursive_Delete'
$task.Triggers[0].Repetition | select -ExpandProperty interval") do
  its('strip') { should eq 'PT5M' }
end

#Title : Test Outcome #4
#Description : Verifying if the file exists and it's contents
describe file('C:\OBOL\Utilities\OBOL_Recursive_Delete\obol_recursive_delete.bat') do
 it { should exist }
 its(:content) { should match 'OBOL_Recursive_Delete.exe /rootdirectory:"M:\Logs" /fileage:30' }
end

#Description : Verifying if 'ODBC Driver 17' is installed
describe package('Microsoft ODBC Driver 17 for SQL Server') do
 it { should be_installed }
end

#Description : Verifying if 'ODcto Tentacle' is installed
describe package('Octopus Deploy Tentacle') do
 it { should be_installed }
end