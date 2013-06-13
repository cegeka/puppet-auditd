# Class: auditd
#
# This module manages auditd
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class auditd (
  $output = 'file'
)
{
  case $::osfamily {
    'RedHat': {
      class { 'auditd::package': }
      class { 'auditd::config': output => $output }
      class { 'auditd::service': }

      Class['auditd::package'] -> Class['auditd::config'] ~> Class['auditd::service']
    }
    default: {
      fail("Class['auditd']: osfamily ${::osfamily} is not supported")
    }
  }
}
