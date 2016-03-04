
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  $packagename = 'proftpd'
  $servicename = 'proftpd'
  $proftpconf  = '/etc/proftpd.conf'

when 'Debian'
  $packagename = 'proftpd-basic'
  $servicename = 'proftpd'
  $proftpconf  = '/etc/proftpd/proftpd.conf'

else
  $packagename = '-_-'
  $servicename = '-_-'

end
