class auditd::service (
  $ensure = 'running',
  $enable = true
)
{
  service { 'auditd':
    ensure    => $ensure,
    hasstatus => true,
    enable    => $enable,
    provider  => 'redhat' #this always needs to be run via the redhat 'service' commands, even on rhel7
  }
}
