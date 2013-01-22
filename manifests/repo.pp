class pulp::repo {
  case $::osfamily {
    'redhat': {
      $repourl = $::operatingsystem ? {
        /(.ed.at|.ent..)/ => 'http://repos.fedorapeople.org/repos/pulp/pulp/v2/stable/$releasever/$basearch/',
        'fedora'          => 'http://repos.fedorapeople.org/repos/pulp/pulp/v2/stable/fedora-$releasever/$basearch/',
        default           => '',
      }

      yumrepo{'pulp':
        name     => 'pulp-v2-stable',
        descr    => 'Pulp v2',
        baseurl  => $repourl,
        enabled  => '1',
        gpgcheck => '0',
        before   => Class['pulp::server::package'],
      }
    }
    default: {
      crit("Don't have a default repo of osfamily '$::osfamily'")
    }
  }
}
