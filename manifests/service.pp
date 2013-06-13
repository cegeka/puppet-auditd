class auditd::service (
  $ensure = 'running',
  $enable = true
)
{
  service { 'auditd':
    ensure    => $ensure,
    hasstatus => true,
    enable    => $enable
  }
}
