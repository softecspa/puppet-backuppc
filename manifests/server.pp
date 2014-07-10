class backuppc::server (
  $user         = 'backuppc',
  $home         = '/var/lib/backuppc',
  $user_uid     = '',
  $user_gid     = '',
  $server_tag   = '',
  $use_ssh_auth = true,

) inherits backuppc::params {

  if $user == '' {
    fail ('please, specify a user')
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

  $real_home = $home? {
    ''      => undef,
    default => $home,
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
  } ->

  package {$backuppc::params::package_name:
    ensure  => present
  }

  if $use_ssh_auth {
    exec {'gen_keypair_backuppc':
      command => "ssh-keygen -t rsa -N '' -f ${home}/.ssh/id_rsa",
      user    => $user,
      creates => "${home}/.ssh/id_rsa",
      path    => $::path,
      require => User[$user]
    }

    if $server_tag != '' {
      # if is defined a tag in server_side, pubkey of the user will be exported (if exists)
      class {'backuppc::server::export_key':
        user        => $user,
        server_tag  => $server_tag,
        require     => Exec['gen_keypair_backuppc']
      }
    }
  }
}

