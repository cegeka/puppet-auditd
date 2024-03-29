class auditd::config (
  $output = 'file'
)
{
  case $output {
    'file': {
      $file_output   = 'yes'
      $syslog_output = 'no'
    }
    'syslog': {
      $file_output   = 'no'
      $syslog_output = 'yes'
    }
    default: {
      fail("Class[${title}]: parameter output must be syslog or file")
    }
  }

  file { 'auditd/config':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    path    => '/etc/audit/auditd.conf',
    content => template('auditd/etc/audit/auditd.conf.erb')
  }

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemrelease {
        default: {
          $path = '/etc/audit/rules.d/puppet.rules'
        }
      }
    }

    default: {
      fail("Class['auditd::config']: osfamily ${::osfamily} is not supported")
    }
  }

  concat { 'auditd/rules':
    path    => $path,
    owner   => 'root',
    group   => 'root',
    mode    => '0640'
  }

  concat::fragment { 'auditd/rules/header':
    target  => 'auditd/rules',
    order   => 0,
    content => template('auditd/etc/audit/audit.rules.erb')
  }

  case $::os[release][major] {
    '7': {
      $audisp_base = '/etc/audisp'
    }
    default: {
      $audisp_base = '/etc/audit'
    }
  }

  $audisp =
  file { 'audispd/config':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    path    => "${audisp_base}/audispd.conf",
    content => template('auditd/etc/audisp/audispd.conf.erb')
  }

  file { 'audispd/plugins/af_unix':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    path    => "${audisp_base}/plugins.d/af_unix.conf",
    content => template('auditd/etc/audisp/plugins.d/af_unix.conf.erb')
  }

  file { 'audispd/plugins/syslog':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    path    => "${audisp_base}/plugins.d/syslog.conf",
    content => template('auditd/etc/audisp/plugins.d/syslog.conf.erb')
  }
}
