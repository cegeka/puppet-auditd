define auditd::rule (
  $expression = undef,
  $order      = 10
)
{
  case $::osfamily {
    'RedHat': {
      if $expression {
        if ($order > 0) {
          concat::fragment { "auditd/rules/${title}":
            target  => 'auditd/rules',
            order   => $order,
            content => "${expression}\n"
          }
        }
        else {
          fail("Auditd::Rule[${title}]: parameter order must be a strictly positive integer")
        }
      }
      else {
        fail("Auditd::Rule[${title}]: required parameter expression must be a non-empty string")
      }
    }
    default: {
      fail("Auditd::Rule[${title}]: osfamily ${::osfamily} is not supported")
    }
  }
}
