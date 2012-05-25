class pulp::admin (
$server,
$withrepo = $pulp::params::withrepo,
$config   = $pulp::params::adminconfig,
$packages = $pulp::params::adminpkgs
) inherits pulp::params {

  package{$packages:
    ensure => 'installed',
  }

  file{$config:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pulp/admin.conf.erb'),
    require => Package[$packages],
  }

  if $withrepo {
    include pulp::repo
    Class['pulp::repo'] -> Package[$packages]
  }
}
