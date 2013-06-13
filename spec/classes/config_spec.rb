#!/usr/bin/env rspec

require 'spec_helper'

describe 'auditd::config' do
  context 'on osfamily RedHat' do
    let (:facts) { {
      :osfamily => 'RedHat'
    } }

    context 'with faulty input' do
      let (:params) { {
        :output => 'test'
      } }

      it { expect { subject}.to raise_error(
        Puppet::Error, /parameter output must be syslog or file/
      )}
    end

    context 'without params' do
      let (:params) { { } }

      it { should contain_class('auditd::config').with(

      )}

      it { should contain_file('auditd/config').with(
        :ensure  => 'file',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0640',
        :path    => '/etc/audit/auditd.conf'
      )}

      it { should contain_concat('auditd/rules').with(
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0640',
        :path    => '/etc/audit/audit.rules'
      )}

      it { should contain_concat__fragment('auditd/rules/header').with(
        :target => 'auditd/rules',
        :order  => 0
      )}

      it { should contain_file('audispd/config').with(
        :ensure  => 'file',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0640',
        :path    => '/etc/audisp/audispd.conf'
      )}

      it { should contain_file('audispd/plugins/af_unix').with(
        :ensure  => 'file',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0640',
        :path    => '/etc/audisp/plugins.d/af_unix.conf',
        :content => /^active = yes$/
      )}

      it { should contain_file('audispd/plugins/syslog').with(
        :ensure  => 'file',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0640',
        :path    => '/etc/audisp/plugins.d/syslog.conf',
        :content => /^active = no$/
      )}
    end

    context 'with output => syslog' do
      let (:params) { { :output => 'syslog' } }

      it { should contain_file('audispd/plugins/af_unix').with(
        :content => /^active = no$/
      )}

      it { should contain_file('audispd/plugins/syslog').with(
        :content => /^active = yes$/
      )}
    end
  end
end
