class backuppc::client (
  $user         = 'backuppc',
  $user_gid     = '',
  $user_uid     = '',
  $home         = '',
  $server_tag   = '',
  $use_ssh_auth = true,
) inherits backuppc::params{

  $real_home = $home?{
    ''      => "/var/lib/${user}",
    default => $home
  }

  if ($user_uid != '') and (! is_numeric($user_uid)) {
    fail ('user_uid must be integer')
  }

  if ($user_gid != '') and (! is_numeric($user_gid)) {
    fail ('user_gid must be integer')
  }

  $real_uid = $user_uid? {
    ''      => undef,
    default => $user_uid
  }

  $real_gid = $user_gid? {
    ''      => undef,
    default => $user_gid
  }

  if $user_gid != '' {
    group {$user:
      ensure  => present,
      gid     => $real_gid,
      before  => User[$user],
    }
  }

  user {$user:
    ensure      => present,
    comment     => 'Backuppc',
    gid         => $real_gid,
    home        => $real_home,
    managehome  => true,
    uid         => $real_uid,
  }


  if ($use_ssh_auth) and ($server_tag != '') {
    Ssh_authorized_key <<| tag == $server_tag |>> {
      user    => $user,
      require => User[$user]
    }
  }
}
