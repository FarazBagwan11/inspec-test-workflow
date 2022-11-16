describe file('C:/Windows/explorer.exe') do
    it { should exist }
    it { should be_file }
  end

describe windows_task('\Microsoft\Windows\AppID\PolicyConverter') do
    it { should exist }
    it { should be_disabled }
    its('logon_mode') { should eq 'Interactive/Background' }
   # its('last_result') { should cmp 267011 }
    its('task_to_run') { should cmp '%Windir%\system32\appidpolicyconverter.exe' }
  end
