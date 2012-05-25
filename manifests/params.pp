class pulp::params {
  $serverconfig   = '/etc/pulp/pulp.conf'
  $consumerconfig = '/etc/pulp/consumer/consumer.conf'
  $adminconfig    = '/etc/pulp/admin/admin.conf'
  case $::osfamily {
    'redhat': {
      $serverpkgs   = 'pulp'
      $adminpkgs    = 'pulp-admin'
      $consumerpkgs = 'pulp-consumer'
      $serversvcs   = 'pulp-server'
      $consumersvcs = 'pulp-agent'
      $withrepo     = true
    }
    default: {
      warn("No defaults set for osfamily '$::osfamily'")
      $withrepo = false
    }
  }
}
