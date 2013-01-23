class pulp::server (
$packages       = $pulp::params::serverpkgs,
$admin_user     = $pulp::params::admin_user,
$admin_pass     = $pulp::params::admin_pass,
$database_name  = $pulp::params::database_name,
$database_host  = $pulp::params::database_host,
$database_port  = $pulp::params::database_port,
$updatedb       = $pulp::params::updatedb,
$messaging_host = $pulp::params::messaging_host,
$messaging_port = $pulp::params::messaging_port,
$config         = $pulp::params::serverconfig,
) inherits pulp::params {
  anchor{'pulp::server::start':}
  anchor{'pulp::server::end':}

  include pulp::server::package
  include pulp::server::updatedb
  include pulp::server::config
  #include pulp::server::service


  Anchor['pulp::server::start']   -> Class['pulp::server::package']
  Class['pulp::server::package']  -> Class['pulp::server::config']
  Class['pulp::server::config']   -> Class['pulp::server::updatedb']
  Class['pulp::server::updatedb'] -> Anchor['pulp::server::end']
}
