#!/usr/bin/env rspec

require 'spec_helper'

describe 'auditd::package' do
  context 'on osfamily RedHat' do
    let (:facts) { {
      :osfamily => 'RedHat'
    } }

    context 'with faulty input' do
      context 'with version => running' do
        let (:params) { {
          :version => 'running'
        } }

        it { expect { subject }.to raise_error(
          Puppet::Error, /parameter version must be present, latest or absent/
        )}
      end
    end

    context 'without parameters' do
      let (:params) { { } }

      it { should contain_class('auditd::package').with(
        :version => 'present'
      )}

      it { should contain_package('audit').with(
        :ensure => 'present'
      )}
    end

    context 'with ensure => absent' do
      let (:params) { {
        :version => 'absent'
      } }

      it { should contain_package('audit').with(
        :ensure => 'absent'
      )}
    end
  end
end
