# puppet2sitepp @ftpusers
define proftpd::user(
                      $ensure               = 'present',
                      $username             = $name,
                      $password             = undef,
                      $home                 = undef,
                      $managehome           = true,
                      $allowdupe            = false,
                      $uid                  = undef,
                      $gid                  = undef,
                      $shell                = '/bin/false',
                      $chroot               = true,
                      $disable_ssh_user     = true,
                      $restrict_ssh_to_sftp = false,
                      $groups               = undef,
                      $login_ips            = undef,
                    ) {
  if($ensure=='present')
  {
    if($chroot)
    {
      if($restrict_ssh_to_sftp)
      {
        if ($groups == undef)
        {
          $user_groups=[ 'ftpchroot', 'sftp' ]
        } else {
          $user_groups=$groups
        }
        $require=Group[ 'ftpchroot', 'sftp' ]
      }
      else
      {
        if ($groups == undef)
        {
          $user_groups=[ 'ftpchroot' ]
        } else {
          $user_groups=$groups
        }
        $require=Group['ftpchroot']
      }
    }
    else
    {
      if($restrict_ssh_to_sftp)
      {
        if ($groups == undef)
        {
          $user_groups=[ 'sftp' ]
        } else {
          $user_groups=$groups
        }
        $require=Group['sftp']
      }
      else
      {
        if ($groups == undef)
        {
          $user_groups=undef
        } else {
          $user_groups=$groups
        }
        $require=undef
      }
    }

    if($login_ips!=undef)
    {
      validate_array($login_ips)

      proftpd::class { "loginips_${username}":
        ip => $login_ips,
      }

      ->

      proftpd::limitlogin { "limit_login_${username}":
        limituser  => [ $username ],
        allowclass => "loginips_${username}",
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

    if ($groups != undef)
    {
      validate_array($groups)
    }

    user { $username:
      uid        => $uid,
      gid        => $gid,
      password   => $password,
      managehome => $managehome,
      home       => $home,
      allowdupe  => $allowdupe,
      groups     => $user_groups,
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
  elsif ($ensure=='absent')
  {
    user { $username:
      ensure     => $ensure,
      uid        => $uid,
      gid        => $gid,
      password   => $password,
      managehome => $managehome,
      home       => $home,
      allowdupe  => $allowdupe,
      groups     => $user_groups,
      shell      => $shell,
      require    => $require,
      membership => inclusive,
    }
  }
  else
  {
    fail("unsupported ensure: ${ensure} valid: present/absent")
  }
}
