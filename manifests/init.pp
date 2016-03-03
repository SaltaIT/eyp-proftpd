#
class proftpd (
                $port='21',
                $use_ipv6=false,
                $servername='private server',
                $serverident=undef,
                $deferwelcome=true,
                $require_valid_shell=false,
              ) inherits proftpd::params {

  #
  Exec {
		path => '/bin:/sbin:/usr/bin:/usr/sbin',
	}

  package { $proftpd_package:
    ensure => 'installed',
  }

  group { 'ftpchroot':
    ensure => 'present',
  }

  file { '/etc/proftpd/proftpd.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/proftpdconf.erb"),
    notify  => Service['proftpd'],
  }

  service { 'proftpd':
    ensure  => 'running',
    enable  => true,
    require => [
                 File['/etc/proftpd/proftpd.conf'],
                 Group['ftpchroot'],
                 Package[$proftpd_package],
               ],
  }


}
