define proftpd::user(
                            $username=$name,
                            $password=undef,
                            $home=undef,
                            $managehome=true,
                            $allowdupe=false,
                            $uid=undef,
                            $gid=undef,
                            $shell='/bin/false',
                            $chroot=true,
                            $disable_ssh_user=true,
                            $restrict_ssh_to_sftp=false,
                            $extra_groups=undef,
                          ) {
  #
  if($chroot)
  {
    if($restrict_ssh_to_sftp)
    {
      if ($extra_groups == undef)
      {
        $groups=[ 'ftpchroot', 'sftp' ]
      } else {
        $groups=$extra_groups
      }
      $require=Group[ 'ftpchroot', 'sftp' ]
    }
    else
    {
      if ($extra_groups == undef)
      {
        $groups=[ 'ftpchroot' ]
      } else {
        $groups=$extra_groups
      }
      $require=Group['ftpchroot']
    }
  }
  else
  {
    if($restrict_ssh_to_sftp)
    {
      if ($extra_groups == undef)
      {
        $groups=[ 'sftp' ]
      } else {
        $groups=$extra_groups
      }
      $require=Group['sftp']
    }
    else
    {
      if ($extra_groups == undef)
      {
        $groups=undef
      } else {
        $groups=$extra_groups
      }
      $require=undef
    }
  }

  if($restrict_ssh_to_sftp)
  {
    if(!defined(Group['sftp']))
    {
      group { 'sftp':
        ensure => 'present',
      }
    }
  }

  if ($extra_groups != undef)
  {
    validate_array($extra_groups)

  }

  user { $username:
    uid        => $uid,
    gid        => $gid,
    password   => $password,
    managehome => $managehome,
    home       => $home,
    allowdupe  => $allowdupe,
    groups     => $groups,
    shell      => $shell,
    require    => $require,
    membership => inclusive,
  }

  if($disable_ssh_user)
  {
    if(defined(Class['openssh::server']))
    {
      openssh::denyuser { $username: }
    }
    else
    {
      fail('unable to disable ssh, class openssh::server not defined')
    }
  }
  else
  {
    if($restrict_ssh_to_sftp)
    {
      if(defined(Class['openssh::server']))
      {
        openssh::match { "match openssh ${username} ${uid}":
          users           => [$username],
          forcecommand    => $::openssh::params::sftp_server,
          chrootdirectory => '%h',
          require         => Group['sftp'],
        }
      }
      else {
        fail('unable to enable sftp, class openssh::server not defined')
      }
    }
  }

}
