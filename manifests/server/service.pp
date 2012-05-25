class pulp::server::service {
  service{$pulp::server::services:
    ensure  => 'running',
    enable  => true,
    require => Package[$pulp::server::packages],
  }

  #Do any os specific initialization here.
  case $::osfamily {
    'redhat': {
      #This feels dirty, but there isn't a way around it without replacing
      #the init script
      exec{'pulp-init':
        command => '/sbin/service pulp init',
        unless  => '/usr/bin/test -e /var/lib/pulp/init.flag',
        before  => Service[$pulp::server::services],
      }
    }
    default: {}
  }
}
