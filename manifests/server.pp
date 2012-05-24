class pulp::server (
$packages=$pulp::params::serverpkgs,
$withrepo=$pulp::params::withrepo,
$services=$pulp::params::serversvcs,
$config=$pulp::params::serverconfig
) inherits pulp::params {
  anchor{'pulp::server::start':}
  anchor{'pulp::server::end':}

  include pulp::server::package
  include pulp::server::config
  include pulp::server::service

  Anchor['pulp::server::start']   -> Class['pulp::server::package']
  Class['pulp::server::package']  ~> Class['pulp::server::service']
  Class['pulp::server::package']  -> Class['pulp::server::config']
  Class['pulp::server::config']   ~> Class['pulp::server::service']
  Class['pulp::server::service']  -> Anchor['pulp::server::end']
}
