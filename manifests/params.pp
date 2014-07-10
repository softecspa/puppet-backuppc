class backuppc::params {

  $package_name = $::operatingsystem ? {
    /(?i:Debian|Ubuntu)/  => 'backuppc',
    default               => 'backuppc'
  }

}
