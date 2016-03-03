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
                            $disablessh=true,
                          ) {
  #
  if($chroot)
  {
    $groups=[ 'ftpchroot' ]
    $require=Group['ftpchroot']
  }
  else
  {
    $groups=undef
    $require=undef
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
  }

  if($disablessh)
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

}
