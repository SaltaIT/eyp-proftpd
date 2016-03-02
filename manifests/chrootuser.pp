define proftpd::chrootuser(
                            $username=$name,
                            $password=undef,
                            $home=undef,
                            $allowdupe=false,
                            $uid=undef,
                            $gid=undef,
                          ) {
  #

  user { $username:
    uid        => $uid,
    gid        => $gid,
    password   => $password,
    managehome => true,
    home       => $home,
    allowdupe  => $allowdupe,
    groups     => [ 'ftpchroot' ],
    shell      => '/bin/bash', #TODO, gestio shells
    require    => Group['ftpchroot'],

  }

}
