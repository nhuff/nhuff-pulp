class pulp::params {
  $serverconfig  = '/etc/pulp/server.conf'
  $adminconfig   = '/etc/pulp/admin/admin.conf'
  $admin_user    = 'admin'
  $admin_pass    = 'admin'
  $database_name = 'pulp_database'
  $database_host = $::fqdn
  $database_port = '27017'
  $messaging_host = $::fqdn
  $messaging_port = '5672'
  $pulp_server    = $::fqdn
  case $::osfamily {
    'redhat': {
      $serverpkgs = 'pulp-server'
      $adminpkgs  = 'pulp-admin-client'
      $withrepo   = true
      $updatedb   = '/usr/bin/pulp-manage-db'
    }
    default: {
      warn("No defaults set for osfamily '$::osfamily'")
      $withrepo   = false
      $serverpkgs = ''
      $updatedb   = ''
    }
  }
}
