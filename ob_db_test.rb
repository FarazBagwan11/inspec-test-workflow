# frozen_string_literal: true

# Test #1: Check 7zip installation

describe package('7-Zip 19.00 (x64 edition)') do
  puts 'Check 7zip installation'
  it { should be_installed }
  # its('version') { should eq '19.00.00.0' }
end

# Test #2: Check Crowdstrike installation

describe package('CrowdStrike Windows Sensor') do
  puts 'Check Crowdstrike installation'
  it { should be_installed }
  # its('version') { should eq '6.48.16207.0' }
end

# Test #3: Check Splunkforwarder installation

describe package('UniversalForwarder') do
  puts 'Check Splunkforwarder installation'
  it { should be_installed }
  its('version') { should eq '9.0.1.0' }
end

# Test #4: Check Pester 5.2.2 installation

describe powershell('Get-Module -ListAvailable Pester | Format-Table -Property Name, Version') do
  puts 'Check Pester 5.2.2 installation'
  its('strip') { should include 'Pester' }
  its('strip') { should include '5.2.2' }
end

# Test #5: Check Notepad++ installation

describe package('Notepad++ (32-bit x86)') do
  puts 'Check Notepad++ installation'
  it { should be_installed }
end

# Test #6: Check Standardpstemplate configuration

describe windows_feature('telnet-client') do
  puts 'Check telnet-client installation'
  it { should be_installed }
end

describe powershell('[bool](Test-WSMan -ErrorAction SilentlyContinue)') do
  its('stdout') { should include 'True' }
end

describe directory('C:\software\runonce') do
  puts 'Verifying for runoncedirectory presence'
  it { should exist }
end

# describe package('Octopus Deploy Tentacle') do
#  puts "Verifying for Octopus Deploy Tentacle"
#  it { should be_installed }
# end

describe powershell('Get-ItemProperty -Path "HKLM:System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections"') do
  its('stdout') { should include 'fDenyTSConnections : 0' }
end

describe powershell('Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" -Name "EnableFirewall"') do
  its('stdout') { should include 'EnableFirewall : 0' }
end

describe powershell('Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin"') do
  its('stdout') { should include 'ConsentPromptBehaviorAdmin : 0' }
end

describe powershell('Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA"') do
  its('stdout') { should include 'EnableLUA    : 0' }
end

describe powershell('Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden"') do
  puts 'Verifying if hidden value is set to 1'
  its('stdout') { should include 'Hidden       : 2' }
end

describe powershell('Get-NetFirewallProfile -Name Domain') do
  puts 'Verifying Domain firewall profile is Disabled'
  its('stdout') { should include 'Enabled                         : False' }
end

describe powershell('Get-NetFirewallProfile -Name Public') do
  puts 'Verifying Public firewall profile is Disabled'
  its('stdout') { should include 'Enabled                         : False' }
end

describe powershell('Get-NetFirewallProfile -Name Private') do
  puts 'Verifying Private firewall profile is Disabled'
  its('stdout') { should include 'Enabled                         : False' }
end

# Test #7: Check if domainjoin.ps1 file is present at given location.

describe file('C:\software\runonce\domainjoin.ps1') do
  puts 'Check if domainjoin.ps1 file is present at given location'
  it { should exist }
end

# Test #8: Check if ebsnvme-id.exe file is present at given location for performing dbadisks operation.

describe file('C:\ProgramData\Amazon\Tools\ebsnvme-id.exe') do
  puts 'Check if ebsnvme-id.exe file is present at given location for performing dbadisks operation'
  it { should exist }
end

# Test #9: Check if agent-config.yml file is present at given location.

describe file('C:\ProgramData\Amazon\EC2Launch\config\agent-config.yml') do
  puts 'Check if agent-config.yml file is present at given location'
  it { should exist }
end

# Test #10: Check if setup.exe file is present to run SQL uninstallation.

describe file('C:\SQLServerSetup\setup.exe') do
  puts 'Check if setup.exe file is present to run SQL uninstallation'
  it { should exist }
end

# Test #11: Check if powershell is installed.

describe package('Powershell 7.2.6.0-x64') do
  puts 'Check if powershell is installed'
  it { should be_installed }
end

# Test #12: Check database powershell settings.

describe windows_feature('Failover-Clustering') do
  puts 'Check database powershell settings'
  it { should be_installed }
end

describe windows_feature('RSAT-Clustering') do
  puts 'Verifying for RSAT-Clustering'
  it { should be_installed }
end

describe powershell('(Get-Service -Name winrm ).Status') do
  puts 'Verifying the status of winrm service'
  its('stdout') { should include 'Running' }
end

describe powershell('(Get-Item WSMan:\localhost\Service\Auth\CredSSP).value') do
  puts 'WSManCredSSP is enabled'
  its('stdout') { should include 'true' }
end

# Test #13: Check if windows was rebooted after update.

describe powershell('[bool](Get-WmiObject Win32_NTLogEvent -filter EventCode=6005)') do
  puts 'Check if windows was rebooted after update'
  its('stdout') { should include 'True' }
end
