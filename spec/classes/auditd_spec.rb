#!/usr/bin/env rspec

require 'spec_helper'

describe 'auditd' do
  it { should contain_class 'auditd' }
end
