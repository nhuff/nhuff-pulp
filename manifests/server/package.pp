class pulp::server::package {
  package{$pulp::server::packages:
    ensure => 'installed',
  }
}
