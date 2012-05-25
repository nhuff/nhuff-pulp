class pulp::repo {
  case $::osfamily {
    'redhat': {
      $repourl = $::operatingsystem ? {
        /(.ed.at|.ent..)/ => 'http://repos.fedorapeople.org/repos/pulp/pulp/v1/stable/$releasever/$basearch/',
        'fedora'          => 'http://repos.fedorapeople.org/repos/pulp/pulp/v1/stable/fedora-$releasever/$basearch/',
        default           => '',
      }

      yumrepo{'pulp':
        name     => 'pulp-v1-stable',
        descr    => 'Pulp v1',
        baseurl  => $repourl,
        enabled  => '1',
        gpgcheck => '0',
      }
    }
    default: {
      crit("Don't have a default repo of osfamily '$::osfamily'")
    }
  }
}
