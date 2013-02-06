class pulp::admin (
  $server   = $pulp::params::pulp_server,
  $packages = $pulp::params::adminpkgs,
  $config   = $pulp::params::adminconfig,
  $withrepo = true,
) inherits pulp::params {

  package{$packages:
    ensure => 'installed',
  }

  file_line{'pulp_hostname':
    path    => $config,
    match   => 'host.*=.*',
    line    => "host = ${server}",
    require => Package[$packages]
  }

  if $withrepo {
    include pulp::repo
    Class['pulp::repo'] -> Package[$packages]
  }
}
