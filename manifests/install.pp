# == Class etcd::install
#
# TODO: Create etcd log dir if required
#
class etcd::install inherits etcd::params {
  include '::etcd'

  # Create group and user if required
  if $etcd::manage_user {
    group { $etcd::group: ensure => 'present' }

    user { $etcd::user:
      ensure  => 'present',
      gid     => $etcd::group,
      require => Group[$etcd::group],
      before  => Package['etcd']
    }
  }

  # Create etcd data dir if required
  if $etcd::manage_data_dir {
    file { ['/var/etcd/', $etcd::data_dir] :
      ensure => 'directory',
      owner  => $etcd::user,
      group  => $etcd::group,
      mode   => '0770',
      before => Package['etcd'],
    }
  }

  # Setup resource ordering if appropriate
  if ($etcd::manage_user and $etcd::manage_data_dir) {
    User[$etcd::user] -> File[$etcd::data_dir]
  }
  if ($etcd::manage_user and $etcd::manage_log_dir) {
    User[$etcd::user] -> File[$etcd::log_dir]
  }

  # Install the required package
  package { 'etcd':
    ensure => $etcd::package_ensure,
    name   => $etcd::package_name,
  }

## TODO: Ensure etcd rubygem
#  package { 'etcd_rubygem':
#    name => 'rubygem_etcd??',
#    ensure => 'installed',
#  }
  
}
