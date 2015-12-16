define proftpd::chrootuser($username=$name, $password=undef, $home=undef) {
  #

  user { $username:
    groups     => [ 'ftpchroot' ],
    password   => $password,
    shell      => '/bin/bash', #TODO, gestio shells
    managehome => true,
    home       => $home,
    require    => Group['ftpchroot'],
  }

}
