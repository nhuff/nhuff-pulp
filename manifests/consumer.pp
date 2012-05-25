class pulp::consumer (
$server,
$with_agent = true,
$withrepo   = $pulp::params::withrepo,
$packages   = $pulp::params::consumerpkgs,
$config     = $pulp::params::consumerconfig,
$services   = $pulp::params::consumersvcs
) inherits pulp::params {

  package{$packages: ensure => 'installed'}

  file{$config:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pulp/consumer.conf.erb'),
    require => Package[$packages],
    notify  => Service[$services],
  }

  service{$services:
    ensure     => $with_agent,
    enable     => $with_agent,
    hasstatus  => true,
    hasrestart => true,
  }

  if $withrepo {
    include pulp::repo
    Class['pulp::repo'] -> Package[$packages]
  }
}
