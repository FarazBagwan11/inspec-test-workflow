describe file('C:\Users\Public\Desktop\odbcad32.lnk') do
 it { should exist }
end

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
   describe "Verifying if the Target path " do

                it "of the shortcut" do
                expect(Target).to eq 'C:\\Windows\\SysWOW64\\odbcad32.exe'
                end
        end
end

describe registry_key({
  name: 'ServicesPipeTimeout',
  hive: 'HKEY_LOCAL_MACHINE',
  key: '\System\CurrentControlSet\Control'
 }) do
 it { should exist }
 its('ServicesPipeTimeout') { should eq 60000 }
end

describe windows_task('Service Restart') do
   it { should exist }
  its('task_to_run') { should eq 'C:\\OBOL\\Utilities\\GCSServiceStartRestarter\\Application\\GCSServiceStartRestarter.exe Restart' }
  its('run_as_user') { should eq 'SYSTEM' }
end

describe command("Get-ScheduledTaskInfo 'Service Restart'") do
it {should exist}
output = `powershell.exe  #{"Get-ScheduledTaskInfo 'Service Restart'"}`
 output.to_enum(:scan, /(LastRunTime)(.*)/i).map do |m,|
#puts $` .size
  Restart_LastRunDate= output[($`.size+21),(11)]
  end
   output.to_enum(:scan, /(NextRunTime)(.*)/i).map do |m,|
  Restart_NextRunDate = output[($`.size+21),(11)]
  Restart_NextRunTime = output[($`.size+30),(11)]
  end
  describe "Verifying if the Next Run Time" do

                it "is 2:30:30 AM" do
                puts "Printing NextRunTime: "
                puts Restart_NextRunTime
                #expect(NextRunTime).to eq "2:30:30 AM"
                expect(Restart_NextRunTime).to include ("2:30:30 AM")
                end
        end


  ParsedRestart_NextRunDate = Date.strptime(Restart_NextRunDate, '%m/%d/%Y')
  ParsedRestart_LastRunDate = Date.strptime(Restart_LastRunDate, '%m/%d/%Y')
  puts ParsedRestart_NextRunDate
  puts ParsedRestart_LastRunDate

 describe "Verifying if the frequency of execution" do

                it "is daily" do
                puts "Printing ParsedRestart_NextRunDate is : "
                puts ParsedRestart_NextRunDate
                puts "Printing ParsedRestart_LastRunDate is :"
                puts ParsedRestart_LastRunDate
                expect(ParsedRestart_NextRunDate).to eq (ParsedRestart_LastRunDate+1)

                end
        end
end

describe command("Get-ScheduledTask -TaskName 'Service Restart' \" -Verbose | select description \"") do
it {should exist}
output = `powershell.exe #{"Get-ScheduledTask -TaskName 'Service Restart' \"-Verbose | select description \""}`

puts output
if(output.include?("Performs Windows service restarts"))

puts "Powershell command has the string 'Windows service restarts'"

output.to_enum(:scan,/(Performs)(.*)/i).map do |m,|
#puts ($` .size)
  Restart_Description = output[($`.size),(130)]
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



describe windows_task('Service Monitor') do
   it { should exist }
  its('task_to_run') { should eq 'C:\\OBOL\\Utilities\\GCSServiceStartRestarter\\Application\\GCSServiceStartRestarter.exe Start' }
  its('run_as_user') { should eq 'SYSTEM' }
  #its('start_time') { should eq '14:30' }
end


describe command("Get-ScheduledTaskInfo 'Service Monitor'") do
output = `powershell.exe  #{"Get-ScheduledTaskInfo 'Service Monitor'"}`
 output.to_enum(:scan, /(LastRunTime)(.*)/i).map do |m,|
#puts $` .size
  Monitor_LastRunTime= output[($`.size+30),(10)]
  puts 'Monitor_LastRunTime'
  puts Monitor_LastRunTime
  end
   output.to_enum(:scan, /(NextRunTime)(.*)/i).map do |m,|
  Monitor_NextRunTime = output[($`.size+30),(10)]
  puts 'Monitor_NextRunTime'
  puts Monitor_NextRunTime
  end


  ParsedMonitor_NextRunTime = Time.parse(Monitor_NextRunTime)
  ParsedMonitor_LastRunTime = Time.parse(Monitor_LastRunTime)
  puts 'ParsedMonitor_NextRunTime'
  puts ParsedMonitor_NextRunTime
  puts 'ParsedMonitor_LastRunTime'
  puts ParsedMonitor_LastRunTime

         describe "Verifying if the next execution " do

                it "is 5 minutes from last execution" do

                seconds = (ParsedMonitor_NextRunTime - ParsedMonitor_LastRunTime)
                #puts "printing diff"
                #puts seconds
                expect(seconds).to eq (305)

                end
        end
end

describe command("Get-ScheduledTask -TaskName 'Service Monitor' \" -Verbose | select description \"") do
it {should exist}
output = `powershell.exe #{"Get-ScheduledTask -TaskName 'Service Monitor' \"-Verbose | select description \""}`

puts output
if(output.include?("Monitors"))

puts "Powershell command has the string 'Monitors'"

output.to_enum(:scan,/(Monitors)(.*)/i).map do |m,|
#puts ($` .size)
  Monitor_Description= output[($`.size),(120)]
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

describe windows_task('OBOL_Recursive_Delete') do
   it { should exist }
  its('task_to_run') { should eq 'C:\OBOL\Utilities\OBOL_Recursive_Delete\OBOL_Recursive_Delete.bat' }
  its('run_as_user') { should eq 'SYSTEM' }
end


describe command("Get-ScheduledTaskInfo 'OBOL_Recursive_Delete'") do
output = `powershell.exe  #{"Get-ScheduledTaskInfo 'OBOL_Recursive_Delete'"}`
 output.to_enum(:scan, /(LastRunTime)(.*)/i).map do |m,|
#puts $` .size
  OBOL_LastRunTime= output[($`.size+30),(10)]
  puts 'OBOL_LastRunTime'
  puts OBOL_LastRunTime
  end
   output.to_enum(:scan, /(NextRunTime)(.*)/i).map do |m,|
  OBOL_NextRunTime = output[($`.size+30),(10)]
  puts 'OBOL_NextRunTime'
  puts OBOL_NextRunTime
  end


  ParsedOBOL_NextRunTime = Time.parse(OBOL_NextRunTime)
  ParsedOBOL_LastRunTime = Time.parse(OBOL_LastRunTime)
  puts 'ParsedOBOL_NextRunTime'
  puts ParsedOBOL_NextRunTime
  puts 'ParsedOBOL_LastRunTime'
  puts ParsedOBOL_LastRunTime

         describe "Verifying if the next execution " do

                it "is 5 minutes from last execution" do

                seconds = (ParsedOBOL_NextRunTime - ParsedOBOL_LastRunTime)
                #puts "printing diff"
                #puts seconds
                expect(seconds).to eq (305)

                end
        end
end

describe file('C:\OBOL\Utilities\OBOL_Recursive_Delete\obol_recursive_delete.bat') do
 it { should exist }
 its(:content) { should match 'OBOL_Recursive_Delete.exe /rootdirectory:"M:\Logs" /fileage:30' }
end
