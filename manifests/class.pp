# puppet2sitepp @proftpdclasses
define proftpd::class (
                        $ip,
                        $classname = $name,
                      ) {

  validate_array($ip)

  concat::fragment{ "class ${classname} - ${proftpd::params::proftpd_conf}":
    target  => $proftpd::params::proftpd_conf,
    order   => '10',
    content => template("${module_name}/class.erb"),
  }
}
