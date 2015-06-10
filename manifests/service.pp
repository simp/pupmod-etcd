# == Class etcd::service
#
class etcd::service {
  # Switch service details based on osfamily
  case $::osfamily {
    'RedHat' : {
      # TODO: template sysconfig file.
    }
    default  : {
      fail("OSFamily ${::osfamily} not supported.")
    }
  }

  # Set service status
  service { 'etcd':
    ensure   => $etcd::service_ensure,
    enable   => $etcd::service_enabled,
  }
}
