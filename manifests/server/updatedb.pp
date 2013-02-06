class pulp::server::updatedb 
{
  exec{$pulp::server::updatedb:
    refreshonly => true,
    tries       => '3',
    try_sleep   => '5',
  }
}
