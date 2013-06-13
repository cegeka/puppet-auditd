#!/usr/bin/env rspec

require 'spec_helper'

describe 'auditd::rule' do
  context 'with title execve' do
    let (:title) { 'execve' }

    context 'on osfamily RedHat' do
      let (:facts) { {
        :osfamily => 'RedHat'
      } }

      context 'with faulty input' do
        context 'without params' do
          let (:params) { { } }

          it { expect { subject }.to raise_error(
            Puppet::Error, /required parameter expression must be a non-empty string/
          )}
        end

        context 'with expression => ""' do
          let (:params) { {
            :expression => ''
          } }

          it { expect { subject }.to raise_error(
            Puppet::Error, /required parameter expression must be a non-empty string/
          )}
        end

        context 'with order => 0' do
          let (:params) { {
            :expression => '-a entry,always -F arch=b64 -S execve -F auid>=500',
            :order      => '0'
          } }

          it { expect { subject }.to raise_error(
            Puppet::Error, /parameter order must be a strictly positive integer/
          )}
        end
      end

      context 'with default parameters' do
        let (:params) { {
          :expression => '-a entry,always -F arch=b64 -S execve -F auid>=500'
        } }

        it { should contain_auditd__rule('execve').with(
          :expression => '-a entry,always -F arch=b64 -S execve -F auid>=500',
          :order      => '10'
        )}

        it { should contain_concat__fragment('auditd/rules/execve').with(
          :target  => 'auditd/rules',
          :order   => '10',
          :content => '-a entry,always -F arch=b64 -S execve -F auid>=500'
        )}
      end

      context 'with order => 20 and expression => -a always,exit -F arch=b64 -S open -k access' do
        let (:params) { {
          :expression => '-a always,exit -F arch=b64 -S open -k access',
          :order      => '20'
        } }

        it { should contain_concat__fragment('auditd/rules/execve').with(
          :target  => 'auditd/rules',
          :order   => '20',
          :content => '-a always,exit -F arch=b64 -S open -k access'
        )}
      end
    end
  end
end
