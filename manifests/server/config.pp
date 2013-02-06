class pulp::server::config {
  $admin_user     = $pulp::server::admin_user
  $admin_pass     = $pulp::server::admin_pass
  $database_name  = $pulp::server::database_name
  $database_host  = $pulp::server::database_host
  $database_port  = $pulp::server::database_port
  $messaging_port = $pulp::server::messaging_port
  $messaging_host = $pulp::server::messaging_host
  file{$pulp::server::config:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pulp/server.conf.erb')
  }
}
