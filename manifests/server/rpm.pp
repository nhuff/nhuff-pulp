class pulp::server::rpm {
  package{'pulp-rpm-plugins': 
    ensure  => 'installed',
    notify  => Class['pulp::server::updatedb'],
  }
}
