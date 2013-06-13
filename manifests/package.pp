class auditd::package (
  $version = 'present'
)
{
  case $version {
    'present', 'latest', 'absent': {
      package { 'audit':
        ensure => $version
      }
    }
    default: {
      fail('Class[auditd::package]: parameter version must be present, latest or absent')
    }
  }
}
