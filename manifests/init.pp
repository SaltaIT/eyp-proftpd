#
class proftpd () inherits proftpd::params {

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
