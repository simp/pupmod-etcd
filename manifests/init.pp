# == Class: etcd
#
# Installs and configures etcd.  SSL is enabled by default.
#
# === Parameters
#
# See params.pp
#
# === Examples
#
#  class { etcd: }
#
#  Set a key (basic usage, see function documentation).
#    etcd_cli_set('somekey','someval')
#
#  Get a key's value.
#    etcd_cli_get('somekey')
#
# === Authors
#
# Kyle Anderson <kyle@xkyle.com>
# Mathew Finch <finchster@gmail.com>
# Gavin Williams <fatmcgav@gmail.com>
# Nick Markowski <nmarkowski@keywcorp.com>
#
class etcd (
  $package_ensure              = $etcd::params::package_ensure,
  $package_name                = $etcd::params::package_name,
  $user                        = $etcd::params::user,
  $group                       = $etcd::params::group,
  $manage_user                 = $etcd::params::manage_user,
  $manage_data_dir             = $etcd::params::manage_data_dir,
  $service_ensure              = $etcd::params::service_ensure,
  $service_enabled             = $etcd::params::service_enabled,
  $manage_iptables             = $etcd::params::manage_iptables,
  $client_nets                 = $etcd::params::client_nets,
  $etcd_name                   = $etcd::params::etcd_name,
  $data_dir                    = $etcd::params::data_dir,
  $snapshot_count              = $etcd::params::snapshot_count,
  $heartbeat_interval          = $etcd::params::heartbeat_interval,
  $election_timeout            = $etcd::params::election_timeout,
  $listen_client_urls          = $etcd::params::listen_client_urls,
  $max_snapshots               = $etcd::params::max_snapshots,
  $max_wals                    = $etcd::params::max_wals,
  $cors                        = $etcd::params::cors,
  $initial_advertise_peer_urls = $etcd::params::initial_advertise_peer_urls,
  $initial_cluster             = $etcd::params::initial_cluster,
  $initial_cluster_state       = $etcd::params::initial_cluster_state,
  $initial_cluster_token       = $etcd::params::initial_cluster_token,
  $advertise_client_urls       = $etcd::params::advertise_client_urls,
  $discovery                   = $etcd::params::discovery,
  $discovery_srv               = $etcd::params::discovery_srv,
  $discovery_fallback          = $etcd::params::discovery_fallback,
  $discovery_proxy             = $etcd::params::discovery_proxy,
  $proxy                       = $etcd::params::proxy,
  $cert_dir                    = $etcd::params::cert_dir,
  $ca_file                     = $etcd::params::ca_file,
  $ca_file_target              = $etcd::params::ca_file_target,
  $cert_file                   = $etcd::params::cert_file,
  $cert_file_target            = $etcd::params::cert_file_target,
  $key_file                    = $etcd::params::key_file,
  $key_file_target             = $etcd::params::key_file_target,
  $client_cert_auth            = $etcd::params::client_cert_auth,
  $peer_ca_file                = $etcd::params::peer_ca_file,
  $peer_ca_file_target         = $etcd::params::peer_ca_file_target,
  $peer_cert_file              = $etcd::params::peer_cert_file,
  $peer_cert_file_target       = $etcd::params::peer_cert_file_target,
  $peer_key_file               = $etcd::params::peer_key_file,
  $peer_key_file_target        = $etcd::params::peer_key_file_target,
  $peer_client_cert_auth       = $etcd::params::peer_client_cert_auth,
  $debug                       = $etcd::params::debug,
  $log_package_levels          = $etcd::params::log_package_levels,
  $force_new_cluster           = $etcd::params::force_new_cluster,
  $version                     = $etcd::params::version,
) inherits etcd::params {


  validate_string($package_ensure)
  validate_string($package_name)
  validate_string($user)
  validate_string($group)
  validate_bool($manage_user)
  validate_bool($manage_data_dir)
  validate_string($service_ensure)
  validate_bool($service_enabled)
  validate_bool($manage_iptables)
  validate_net_list($client_nets)
  validate_string($etcd_name)
  validate_absolute_path($data_dir)
  validate_integer($snapshot_count)
  validate_integer($heartbeat_interval)
  validate_integer($election_timeout)
  validate_array($listen_client_urls)
  validate_integer($max_snapshots)
  validate_integer($max_wals)
  if !empty($cors) { validate_array($cors) }
  validate_array($initial_advertise_peer_urls)
  validate_array($initial_cluster)
  validate_string($initial_cluster_state)
  validate_string($initial_cluster_token)
  validate_array($advertise_client_urls)
  if !empty($discovery) { validate_string($discovery) }
  if !empty($discovery_srv) { validate_string($discovery_srv) }
  validate_string($discovery_fallback)
  if !empty($discovery_proxy) { validate_string($discovery_proxy) }
  validate_string($proxy)
  validate_absolute_path($cert_dir)
  validate_absolute_path($ca_file)
  validate_absolute_path($ca_file_target)
  validate_absolute_path($cert_file)
  validate_absolute_path($cert_file_target)
  validate_absolute_path($key_file)
  validate_absolute_path($key_file_target)
  validate_bool($client_cert_auth)
  validate_absolute_path($peer_ca_file)
  validate_absolute_path($peer_ca_file_target)
  validate_absolute_path($peer_cert_file)
  validate_absolute_path($peer_cert_file_target)
  validate_absolute_path($peer_key_file)
  validate_absolute_path($peer_key_file_target)
  validate_bool($peer_client_cert_auth)
  validate_bool($debug)
  if !empty($log_package_levels) { validate_array($log_package_levels) }
  validate_bool($force_new_cluster)
  validate_bool($version)

  anchor { 'etcd::begin': } ->
  class { '::etcd::install': } ->
  class { '::etcd::config': } ~>
  class { '::etcd::service': } ->
  anchor { 'etcd::end': }

}
