class pulp::params {
  $serverconfig = '/etc/pulp/pulp.conf'
  case $::osfamily {
    'redhat': {
      $serverpkgs = ['pulp','pulp-admin']
      $consumerpkgs = 'pulp-consumer'
      $serversvcs = ['pulp-server']
      $withrepo = true
    }
    default: {
      warn("No defaults set for osfamily '$::osfamily'")
      $withrepo = false
    }
  }
}
