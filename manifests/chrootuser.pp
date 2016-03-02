define proftpd::chrootuser(
                            $username=$name,
                            $password=undef,
                            $home=undef,
                            $managehome=true,
                            $allowdupe=false,
                            $uid=undef,
                            $gid=undef,
                            $shell='/bin/bash',
                          ) {
  #

  user { $username:
    uid        => $uid,
    gid        => $gid,
    password   => $password,
    managehome => $managehome,
    home       => $home,
    allowdupe  => $allowdupe,
    groups     => [ 'ftpchroot' ],
    shell      => $shell,
    require    => Group['ftpchroot'],

  }

}
