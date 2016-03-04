
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  $packagename     = 'proftpd'
  $servicename     = 'proftpd'

when 'Debian'
  $packagename     = 'proftpd-basic'
  $servicename     = 'proftpd'

else
  $packagename     = '-_-'
  $servicename     = '-_-'

end
