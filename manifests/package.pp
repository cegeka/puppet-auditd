class auditd::package (
  $version = 'present'
)
{
  case $version {
    'present', 'latest', 'absent': {
      package { ['audit','audispd-plugins']:
        ensure => $version
      }
    }
    default: {
      fail('Class[auditd::package]: parameter version must be present, latest or absent')
    }
  }
}
