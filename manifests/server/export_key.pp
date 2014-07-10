class backuppc::server::export_key (
  $user,
  $server_tag,
) {

  $pub_key = $::backuppc_pubkey

  if $pub_key != '' {
    @@ssh_authorized_key {"backuppc-${::hostname}":
      ensure  => present,
      key     => $pub_key,
      name    => "${user}@${::hostname}",
      type    => 'ssh-rsa',
      tag     => $server_tag
    }
  }
}
