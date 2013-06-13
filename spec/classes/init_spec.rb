#!/usr/bin/env rspec

require 'spec_helper'

describe 'auditd' do
  context 'on osfamily Debian' do
    let (:facts) { {
      :osfamily => 'Debian'
    } }

    it { expect { subject }.to raise_error( Puppet::Error, /not supported/) }
  end

  context 'on osfamily RedHat' do
    let (:facts) { {
      :osfamily => 'RedHat'
    } }

    context 'without parameters' do
      let (:params) { { } }

      it { should contain_class('auditd').with(
        :output => 'file'
      )}

      it { should contain_class('auditd::package') }
      it { should contain_class('auditd::config').with(
        :output => 'file'
      )}
      it { should contain_class('auditd::service') }
    end

    context 'with output => syslog' do
      let (:params) { {
        :output => 'syslog'
      } }

      it { should contain_class('auditd::package') }
      it { should contain_class('auditd::config').with(
        :output => 'syslog'
      )}
      it { should contain_class('auditd::service') }
    end
  end
end
