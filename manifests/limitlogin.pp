# puppet2sitepp @proftpdlimitlogins
define proftpd::limitlogin(
                            $limitloginname = $name,
                            $limituser      = undef,
                            $allowclass     = undef,
                            $defaultaction  = 'DenyAll',
                          ) {

  if($limituser!=undef)
  {
    validate_array($limituser)
  }

  concat::fragment{ "limitlogin ${limitloginname} - ${proftpd::params::proftpd_conf}":
    target  => $proftpd::params::proftpd_conf,
    order   => '20',
    content => template("${module_name}/limitlogin.erb"),
  }
}
