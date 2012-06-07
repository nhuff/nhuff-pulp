class pulp::server::config (
$adminuser,
$adminpass
) {
  file{$pulp::server::config:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pulp/pulp.conf.erb')
  }
}
