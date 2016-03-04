#
class proftpd::params {

	$systemlog_default='/var/log/proftpd/proftpd.log'

	$confdir='/etc/proftpd/'
	$modulesconf='/etc/proftpd/modules.conf'

  case $::osfamily
  {
		'redhat':
		{
			case $::operatingsystemrelease
			{
				/^[5-7].*$/:
				{
					$proftpd_package='proftpd'
					$include_epel=true

					$proftpd_conf='/etc/proftpd.conf'

					$modulepath_default='/usr/libexec/proftpd'
				}
				default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
			}
		}
    'Debian':
    {
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $proftpd_package='proftpd-basic'
							$include_epel=false

							$proftpd_conf='/etc/proftpd/proftpd.conf'

							$modulepath_default='/usr/lib/proftpd'
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
