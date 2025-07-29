define auditd::settings (
  $max_log_file = 10,
)
{

  file { 'auditd/config':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    path    => '/etc/audit/auditd.conf',
    content => template('auditd/etc/audit/auditd.conf.erb')
  }

}
