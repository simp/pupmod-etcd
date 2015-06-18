# == Class: etcd::firewall
#
# This class opens ports for etcd in IPtables.
#
# == Authors
#
# * Nick Markowski <nmarkowski@keywcorp.com>
#
class etcd::firewall inherits etcd::params {
  include '::etcd'
  include 'iptables'

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

}
