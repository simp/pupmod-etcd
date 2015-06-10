# == Class etcd::params
#
## == Parameters ==
#
#ETCD Module Specific Options
#
##  [*package_ensure*]
#
#     Ensure the etcd package in Puppet.
#     default: installed
#
##  [*package_name*]
#
#     Etcd package name to be installed by Puppet.
#     default: etcd
#
##  [*user*]
#
#     Etcd user ensured by Puppet.
#     default: etcd
#
##  [*group*]
#
#     Etcd group ensured by Puppet.
#     default: etcd
#
##  [*manage_user*]
#
#     Boolean, whether or not Puppet should manage the etcd user.
#     default: true
#
##  [*manage_data_dir*]
#
#     Boolean, whether or not to manage the etcd data dir in Puppet.
#     default: true
#
##  [*service_ensure*]
#
#     Etcd service status to be ensured by Puppet.
#     defalt: 'running'
#
##  [*service_enabled*]
#
#     Boolean, whether or not to enable the etcd service.
#     default: true.
#
##  [*manage_iptables*]
#
#     Boolean, whether or not to manage iptables rules in Puppet.
#     default: true
#
#ETCD Service Specific Options
#
## [*etcd_name*]
#
#    Human-readable name for this member.
#    default: "default"
#
## [*data-dir*]
#
#    Path to the data directory.
#    default: /var/etcd/datadir.etcd
#
## [*snapshot-count*]
#
#    Number of committed transactions to trigger a snapshot to disk.
#    default: "10000"
#
## [*heartbeat-interval*]
#
#    Time (in milliseconds) of a heartbeat interval.
#    default: "100"
#
## [*election-timeout*]
#
#    Time (in milliseconds) for an election to timeout.
#    default: "1000"
#
## [*listen-peer-urls*]
#
#    List of URLs to listen on for peer traffic.
#    default: "http://${::fqdn}:2380,http://${::fqdn}:7001"
#
## [*listen-client-urls*]
#
#    List of URLs to listen on for client traffic.
#    default: "http://${::fqdn}:2379,http://${::fqdn}:4001"
#
## [*max-snapshots*]
#
#    Maximum number of snapshot files to retain (0 is unlimited)
#    default: 5
#    The default for users on Windows is unlimited, and manual purging
#    down to 5 (or your preference for safety) is recommended.
#
## [*max-wals*]
#
#    Maximum number of wal files to retain (0 is unlimited)
#    default: 5
#    The default for users on Windows is unlimited, and manual purging
#    down to 5 (or your preference for safety) is recommended.
#
## [*cors*]
#
#    Comma-separated white list of origins for CORS (cross-origin resource sharing).
#    default: none
#
#Clustering Flags
#
#  Initial prefix flags are used in bootstrapping (static bootstrap, discovery-service
#  bootstrap or runtime reconfiguration) a new member, and ignored when restarting an existing member.
#  Discovery prefix flags need to be set when using discovery service.
#
## [*initial-advertise-peer-urls*]
#
#    List of this member's peer URLs to advertise to the rest of the cluster.
#    These addresses are used for communicating etcd data around the cluster.
#    At least one must be routable to all cluster members.
#    default: "http://${::fqdn}:2380,http://${::fqdn}:7001"
#
## [*initial-cluster*]
#
#    Initial cluster configuration for bootstrapping.
#    default: "default=http://${::fqdn}:2380,default=http://${::fqdn}:7001"
#
## [*initial-cluster-state*]
#
#    Initial cluster state ("new" or "existing"). Set to new for all members
#    present during initial static or DNS bootstrapping. If this option is set
#    to existing, etcd will attempt to join the existing cluster. If the wrong
#    value is set, etcd will attempt to start but fail safely.
#    default: "new"
#
## [*initial-cluster-token*]
#
#    Initial cluster token for the etcd cluster during bootstrap.
#    default: "etcd-cluster"
#
## [*advertise-client-urls*]
#
#    List of this member's client URLs to advertise to the rest of the cluster.
#    default: "http://${::fqdn}:2379,http://${::fqdn}:4001"
#
## [*discovery*]
#
#    Discovery URL used to bootstrap the cluster.
#    default: none
#
## [*discovery-srv*]
#
#    DNS srv domain used to bootstrap the cluster.
#    default: none
#
## [*discovery-fallback*]
#
#    Expected behavior ("exit" or "proxy") when discovery services fails.
#    default: "proxy"
#
## [*discovery-proxy*]
#
#    HTTP proxy to use for traffic to discovery service.
#    default: none
#
#Proxy Flags
#
# Proxy prefix flags configures etcd to run in proxy mode.
#
## [*proxy*]
#
#    Proxy mode setting ("off", "readonly" or "on").
#    default: "off"
#
#Security Flags
#
# The security flags help to build a secure etcd cluster.
#
## [*cert-dir*]
#
#    Directory to contain certs.
#    default: /etc/etcd/certs
#
## [*ca-file*]
#
#    Path to copy the ca to.
#    default: $cert_dir/client_ca.pem
#
## [*ca-file-target*]
#
#    Path to the client server TLS CA file.
#    default: /var/lib/puppet/ssl/certs/ca.pem
#
## [*cert-file*]
#
#    Path to copy the cert to.
#    default: $cert_dir/client_cert.pem
#
## [*cert-file-target*]
#
#    Path to the client server TLS cert file.
#    default: /var/lib/puppet/ssl/certs/${::fqdn}.pem
#
## [*key-file*]
#
#    Path to copy the key to.
#    default: $cert_dir/client_key.pem
#
## [*key_file_target*]
#
#    Path to the client server TLS key file.
#    default: /var/lib/puppet/ssl/private_keys/${::fqdn}.pem
#
## [*client-cert-auth*]
#
#    Enable client cert authentication.
#    default: true
#
## [*peer-ca-file*]
#
#    Path to copy peer ca file.
#    default: $cert_dir/peer_ca.pem
#
## [*peer-ca-file-target*]
#
#    Path to the peer server TLS CA file.
#    default: $ca_file_target
#
## [*peer-cert-file*]
#
#    Path to copy peer cert file.
#    default: $cert_dir/peer_cert.pem
#
## [*peer-cert-file-target]
#
#    Path to the peer server TLS cert file.
#    default: $cert_file_target
#
## [*peer-key-file*]
#
#    Path to the copy peer key file.
#    default: $cert_dir/peer_key.pem
#
## [*peer-key-file-target*]
#
#    Path to the peer server TLS key file.
#    default: $key_file_target
#
## [*peer-client-cert-auth*]
#
#    Enable peer client cert authentication.
#    default: true
#
#Logging Flags
#
## [*debug*]
#
#    Drop the default log level to DEBUG for all subpackages.
#    default: false (INFO for all packages)
#
## [*log-package-levels*]
#
#    Set individual etcd subpackages to specific log levels. An example
#    being etcdserver=WARNING,security=DEBUG.
#    default: none (INFO for all packages)
#
#Unsafe Flags
#
# Please be CAUTIOUS when using unsafe flags because it will break the guarantees
# given by the consensus protocol. For example, it may panic if other members in
# the cluster are still alive. Follow the instructions when using these flags.
#
## [*force-new-cluster*]
#
#    Force to create a new one-member cluster. It commits configuration changes
#    in force to remove all existing members in the cluster and add itself.
#    It needs to be set to restore a backup.
#    default: false
#
#Miscellaneous Flags
#
## [*version*]
#
#    Print the version and exit.
#    default: false
#
class etcd::params {
  # Module Specific Options
  $package_ensure              = 'installed'
  $package_name                = 'etcd'
  $user                        = 'etcd'
  $group                       = 'etcd'
  $manage_user                 = true
  $manage_data_dir             = true
  $service_ensure              = 'running'
  $service_enabled             = true
  $manage_iptables             = true
  # ETCD Service Specific Options
  $client_nets                 = hiera('client_nets')
  $etcd_name                   = 'default'
  $data_dir                    = '/var/etcd/datadir.etcd'
  $snapshot_count              = '10000'
  $heartbeat_interval          = '100'
  $election_timeout            = '1000'
  $listen_client_urls          = ["https://${::fqdn}:2379","https://${::fqdn}:4001"]
  $max_snapshots               = '5'
  $max_wals                    = '5'
  $cors                        = ''
  $initial_advertise_peer_urls = ["https://${::fqdn}:2380","https://${::fqdn}:7001"]
  $initial_cluster             = ["default=https://${::fqdn}:2380","default=https://${::fqdn}:7001"]
  $initial_cluster_state       = 'new'
  $initial_cluster_token       = 'etcd-cluster'
  $advertise_client_urls       = ["https://${::fqdn}:2379","https://${::fqdn}:4001"]
  $discovery                   = ''
  $discovery_srv               = ''
  $discovery_fallback          = 'proxy'
  $discovery_proxy             = ''
  $proxy                       = 'off'
  $cert_dir                    = '/etc/etcd/certs'
  $ca_file                     = "$cert_dir/client_ca.pem"
  $ca_file_target              = "/var/lib/puppet/ssl/certs/ca.pem"
  $cert_file                   = "$cert_dir/client_cert.pem"
  $cert_file_target            = "/var/lib/puppet/ssl/certs/${::fqdn}.pem"
  $key_file                    = "$cert_dir/client_key.pem"
  $key_file_target             = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem"
  $client_cert_auth            = true
  $peer_ca_file                = "$cert_dir/peer_ca.pem"
  $peer_ca_file_target         = $ca_file_target
  $peer_cert_file              = "$cert_dir/peer_cert.pem"
  $peer_cert_file_target       = $cert_file_target
  $peer_key_file               = "$cert_dir/peer_key.pem"
  $peer_key_file_target        = $key_file_target
  $peer_client_cert_auth       = true
  $debug                       = false
  $log_package_levels          = ''
  $force_new_cluster           = false
  $version                     = false
}
