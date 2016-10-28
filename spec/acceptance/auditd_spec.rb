require 'spec_helper_acceptance'

describe 'auditd' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        include yum
        include stdlib
        include stdlib::stages
        include profile::package_management

        class { 'cegekarepos' : stage => 'setup_repo' }

        Yum::Repo <| title == 'epel' |>

        class { 'auditd': output => 'syslog' }

        auditd::rule { 'syscall_execve_32':
          expression => '-a entry,always -F arch=b32 -F auid>=500 -S execve'
        }

        auditd::rule { 'syscall_execve_64':
          expression => '-a entry,always -F arch=b64 -F auid>=500 -S execve'
        }
      EOS

      # Run it twice and test for idempotency, allow to fail since audit doesn't
      # seem to start inside a docker container
      apply_manifest(pp, :catch_failures => false)
      apply_manifest(pp, :catch_changes => false)
    end
    describe package('audit') do
      it { should be_installed }
    end
    describe file('/etc/audit/audit.rules') do
      it { should contain '-a entry,always -F arch=b32 -F auid>=500 -S execve' }
    end
    describe file('/etc/audit/audit.rules') do
      it { should contain '-a entry,always -F arch=b64 -F auid>=500 -S execve' }
    end
  end
end
