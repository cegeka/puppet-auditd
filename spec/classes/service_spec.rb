#!/usr/bin/env rspec

require 'spec_helper'

describe 'auditd::service' do
  let (:facts) { {
    :osfamily => 'RedHat'
  } }

  context 'with faulty input' do

  end

  context 'without parameters' do
    let (:params) { { } }

    it { should contain_class('auditd::service').with(
      :ensure => 'running',
      :enable => 'true'
    )}
  end

  context 'with ensure => running and enable => true' do
    let (:params) { { :ensure => 'running', :enable => true } }

    it { should contain_service('auditd').with(
      :ensure    => 'running',
      :hasstatus => 'true',
      :enable    => 'true'
    )}
  end

  context 'with ensure => stopped and enable => false' do
    let (:params) { { :ensure => 'stopped', :enable => false } }

    it { should contain_service('auditd').with(
      :ensure    => 'stopped',
      :hasstatus => 'true',
      :enable    => 'false'
    )}
  end
end
