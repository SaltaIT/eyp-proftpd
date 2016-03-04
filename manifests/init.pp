#
class proftpd (
                $port                = '21',
                $use_ipv6            = false,
                $servername          = 'private server',
                $serverident         = undef,
                $deferwelcome        = true,
                $require_valid_shell = false,
                $maxinstances        = '30',
                $allowoverwrite      = true,
                $transferlog         = undef,
                $systemlog           = $proftpd::params::systemlog_default,
                $user                = $proftpd::params::user_default,
                $group               = $proftpd::params::group_default,
                $umask_files         = '022',
                $umask_dirs          = '022',
                $modulepath          = $proftpd::params::modulepath_default,
              ) inherits proftpd::params {

  #
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  if($proftpd::params::include_epel)
  {
    include ::epel

    #marranada per poder fer include en lloc de instanciacio
    $require_epel=Class['epel']
  }
  else
  {
    $require_epel=undef
  }

  package { $proftpd::params::proftpd_package:
    ensure  => 'installed',
    require => $require_epel,
  }

  group { 'ftpchroot':
    ensure => 'present',
  }

  file { $proftpd::params::proftpd_conf:
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/proftpdconf.erb"),
    notify  => Service['proftpd'],
  }

  file { $proftpd::params::confdir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
    require => Package[$proftpd::params::proftpd_package],
  }

  file { $proftpd::params::modulesconf:
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File[$proftpd::params::confdir],
    content => template("${module_name}/modules.erb"),
    notify  => Service['proftpd'],
  }

  service { 'proftpd':
    ensure  => 'running',
    enable  => true,
    require => [
                File[$proftpd::params::proftpd_conf],
                Group['ftpchroot'],
                Package[$proftpd::params::proftpd_package],
              ],
  }


}
