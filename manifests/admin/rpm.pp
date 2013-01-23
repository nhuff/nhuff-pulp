class pulp::admin::rpm {
  Class['pulp::admin'] -> Class['pulp::admin::rpm']
  package{'pulp-rpm-admin-extensions': ensure => 'installed'}
}
