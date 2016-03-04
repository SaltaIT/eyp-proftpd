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

					$load_tls=false
					$load_site_misc=false
					$load_tlsmemcache=false
					$load_ctrlsadmin=false
					$load_dynmasq=false
					$load_uniqueid=false
					$load_copy=false
					$load_deflate=false
					$load_ifversion=false

					$user_default='ftp'
					$group_default='ftp'
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

							$load_tls=true
							$load_site_misc=true
							$load_tlsmemcache=true
							$load_ctrlsadmin=true
							$load_dynmasq=true
							$load_uniqueid=true
							$load_copy=true
							$load_deflate=true
							$load_ifversion=true

							$user_default='proftpd'
							$group_default='nogroup'

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
