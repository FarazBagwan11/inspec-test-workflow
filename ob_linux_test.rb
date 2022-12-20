# frozen_string_literal: true

# Test Component 1: Linux-packages

describe package('adcli') do
  it { should be_installed }
end

describe package('chrony ') do
  it { should be_installed }
end

describe package('krb5-workstation') do
  it { should be_installed }
end

describe package('libnl') do
  it { should be_installed }
end

describe package('lsof') do
  it { should be_installed }
end

describe package('nano') do
  it { should be_installed }
end

describe package('net-tools') do
  it { should be_installed }
end

describe package('ntpdate') do
  it { should be_installed }
end

describe package('oddjob') do
  it { should be_installed }
end

describe package('oddjob-mkhomedir') do
  it { should be_installed }
end

describe package('openldap-clients') do
  it { should be_installed }
end

describe package('policycoreutils-python') do
  it { should be_installed }
end

describe package('realmd') do
  it { should be_installed }
end

describe package('samba-common') do
  it { should be_installed }
end

describe package('samba-common-tools') do
  it { should be_installed }
end

describe package('screen') do
  it { should be_installed }
end

describe package('sssd') do
  it { should be_installed }
end

describe package('sysstat') do
  it { should be_installed }
end

describe package('tar') do
  it { should be_installed }
end

describe package('tmux') do
  it { should be_installed }
end

describe package('wget') do
  it { should be_installed }
end

# Test Component 2: Linux-base-config

describe bash('ls -dl /etc/ssh/sshd_config') do
  its('stdout') { should include '-rw-------' }
end

describe bash('ls -dl /etc/crontab') do
  its('stdout') { should include '-rw-------' }
end

describe bash('ls -dl /etc/cron.hourly') do
  its('stdout') { should include 'drwx------' }
end

describe bash('ls -dl /etc/cron.daily') do
  its('stdout') { should include 'drwx------' }
end

describe bash('ls -dl /etc/cron.weekly') do
  its('stdout') { should include 'drwx------' }
end

describe bash('ls -dl /etc/cron.monthly') do
  its('stdout') { should include 'drwx------' }
end

describe bash('ls -dl /etc/cron.d') do
  its('stdout') { should include 'drwx------' }
end

describe file('/etc/chrony.conf') do
  it { should exist }
  its('content') { should include 'server ntp.olympus.gaia.kosmos iburst' }
end

describe file('/etc/sudoers') do
  it { should exist }
  its('content') { should include '%dlg-iassrv-la  ALL=(ALL)       ALL ' }
end

describe file('/etc/motd') do
  it { should exist }
  its('content') do
    should include "\n       __|  __|_  )\n       _|  (     /   Amazon Linux 2 AMI\n      ___|\\___|___|\n\nhttps://aws.amazon.com/amazon-linux-2/\n"
  end
end

describe file('/etc/skel/.bash_profile') do
  it { should exist }
  its('content') { should include 'export HISTTIMEFORMAT="%Y-%m-%dT%T "' }
end

describe file('/root/.bash_profile') do
  it { should exist }
  its('content') { should include 'export HISTTIMEFORMAT="%Y-%m-%dT%T "' }
end

describe file('/root/.bash_profile') do
  it { should exist }
  its('content') { should include 'export HISTTIMEFORMAT="%Y-%m-%dT%T "' }
end

describe file('/etc/profile.d/timeout.sh') do
  it { should exist }
  its('content') { should include 'TMOUT=3600' }
end

describe file('/etc/security/limits.conf') do
  it { should exist }
  its('content') { should include '*               soft    core            0' }
end

describe file('/etc/ssh/sshd_config') do
  it { should exist }
  its('content') { should include 'X11Forwarding no' }
  its('content') { should include 'LogLevel INFO' }
  its('content') { should include '#PasswordAuthentication' }
  its('content') { should include '#IgnoreRhosts' }
  its('content') { should include '#X11Forwarding' }
  its('content') { should include '#LogLevel' }
end

describe file('/etc/ssh/sshd_config') do
  it { should exist }
  its('content') { should include 'X11Forwarding no' }
end

describe file('/etc/ssh/sshd_config') do
  it { should exist }
  its('content') { should include 'PasswordAuthentication yes' }
end

describe file('/etc/postfix/main.cf') do
  it { should exist }
  its('content') { should include 'relayhost=smtp.olympus.gaia.kosmos:8080' }
end

describe file('/etc/yum.conf') do
  it { should exist }
  its('content') { should include 'proxy=https://proxy.olympus.gaia.kosmos:8080' }
end

# Test Component 3: linux-splunk

describe package('splunkforwarder') do
  it { should be_installed }
end

# Test Component 4: linux-crowdstrike

describe package('falcon-sensor.x86_64') do
  it { should be_installed }
end
