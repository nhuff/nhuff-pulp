class pulp::server::package {
  package{$pulp::server::packages:
    ensure => 'installed',
  }

  if $pulp::server::withrepo {
    include pulp::repo
    Yumrepo['pulp'] -> Package[$pulp::server::packages]
  }
}
