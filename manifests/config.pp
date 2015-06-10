# == Class etcd::config
#
class etcd::config {
  case $::osfamily {
    'RedHat' : {

      file { '/etc/sysconfig/etcd':
        ensure  => present,
        owner   => $etcd::user,
        group   => $etcd::group,
        mode    => '0644',
        content => template('etcd/etcd.sysconfig.erb'),
      }

      file { '/etc/etcd':
        ensure => directory,
        owner  => $etcd::user,
        group  => $etcd::group,
        mode   => '0555'
      }
    }
    default  : {
      fail("OSFamily ${::osfamily} not supported.")
    }
  }


  # Export iptables rules.
  if $etcd::manage_iptables {
    $url_ports = get_ports([$etcd::initial_advertise_peer_urls,$etcd::initial_cluster,
                            $etcd::advertise_client_urls, $etcd::listen_client_urls])
    if !empty(url_ports) {
      @@iptables::add_tcp_stateful_listen { "Allow etcd on ${::hostname}":
        client_nets => $::hostname,
        dports      => $url_ports
      }
    }
    Iptables::Add_tcp_stateful_listen <<| tag == 'etcd' |>>
  }


  if $etcd::client_cert_auth or $etcd::peer_client_cert_auth {
    file { $etcd::cert_dir:
      ensure => directory,
      mode   => 550,
      owner  => 'root',
      group  => $etcd::group,
    }
  }

  # Enable ssl client <==> server
  if $etcd::client_cert_auth {
    file { $etcd::cert_file:
      ensure  => present,
      source  => $etcd::cert_file_target,
      mode    => 540,
      owner   => 'root',
      group   => $etcd::group,
      require => File[$etcd::cert_dir]
    }

    file { $etcd::key_file:
      ensure  => present,
      source  => $etcd::key_file_target,
      mode    => 540,
      owner   => 'root',
      group   => $etcd::group,
      require => File[$etcd::cert_dir]
    }

    file { $etcd::ca_file:
      ensure => present,
      source => $etcd::ca_file_target,
      mode   => 540,
      owner  => 'root',
      group  => $etcd::group,
      require => File[$etcd::cert_dir]
    }
  }

  # Enable ssl server <==> server
  if $etcd::peer_client_cert_auth {
    file { $etcd::peer_cert_file:
      ensure  => present,
      source  => $etcd::peer_cert_file_target,
      mode    => 540,
      owner   => 'root',
      group   => $etcd::group,
      require => File[$etcd::cert_dir]
    }

    file { $etcd::peer_key_file:
      ensure  => present,
      source  => $etcd::peer_key_file_target,
      mode    => 540,
      owner   => 'root',
      group   => $etcd::group,
      require => File[$etcd::cert_dir]
    }

    file { $etcd::peer_ca_file:
      ensure => present,
      source => $etcd::peer_ca_file_target,
      mode   => 540,
      owner  => 'root',
      group  => $etcd::group,
      require => File[$etcd::cert_dir]
    }
  }

}
