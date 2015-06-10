require 'spec_helper'

describe 'etcd', :type => :class do
  describe 'On an unknown OS' do
    let(:facts) { {
      :osfamily => 'Unknown',
      :client_nets => '192.168.122.0/24'
    } }
    it { should raise_error() }
  end

  describe 'On a Redhat OS' do
    let(:facts) { {
        :osfamily => 'Redhat',
        :fqdn     => 'etcd.test.local',
        :client_nets => '192.168.122.0/24'
      } }

    context 'With defaults' do

      # etcd::init resources
      it { should create_class('etcd') }
      it { should contain_class('etcd::params') }
      it { should contain_anchor('etcd::begin') }
      it { should create_class('etcd::install').that_requires('Anchor[etcd::begin]')}
      it { should create_class('etcd::config').that_requires('Class[etcd::install]').that_notifies('Class[etcd::service]')}
      it { should create_class('etcd::service').that_comes_before('Anchor[etcd::end]')}
      it { should contain_anchor('etcd::end') }
      
      # etcd::install resources
      it { should contain_group('etcd').with_ensure('present') }
      it { should contain_user('etcd').with_ensure('present').with_gid('etcd').that_requires('Group[etcd]') }
      it { should contain_file('/var/etcd/datadir.etcd/').with({
          'ensure' =>'directory',
          'owner'  => 'etcd',
          'group'  => 'etcd',
          'mode'   => '0770'
        }).that_comes_before('Package[etcd]') }
      it { should contain_package('etcd').with_ensure('installed')}
      it { should contain_file('/etc/etcd') }
      
      # etcd::config resources
      it { should contain_file('/etc/sysconfig/etcd').with({
          'ensure' => 'present',
          'owner'  => 'etcd',
          'group'  => 'etcd',
          'mode'   => '0644'
        }) }

      it { should contain_file('/etc/etcd/certs').with({
        'ensure' => 'directory',
        'mode'   => '550',
        'owner'  => 'root',
        'group'  => 'etcd'
      }) }

      it { should contain_file('/etc/etcd/certs/client_ca.pem').with({
        'ensure' => 'present',
        'mode'   => '540',
        'owner'  => 'root',
        'group'  => 'etcd'
      }) }

      it { should contain_file('/etc/etcd/certs/client_cert.pem').with({
        'ensure' => 'present',
        'mode'   => '540',
        'owner'  => 'root',
        'group'  => 'etcd'
      }) }

      it { should contain_file('/etc/etcd/certs/client_key.pem').with({
        'ensure' => 'present',
        'mode'   => '540',
        'owner'  => 'root',
        'group'  => 'etcd'
      }) } 

      it { should contain_file('/etc/etcd/certs/peer_ca.pem').with({
        'ensure' => 'present',
        'mode'   => '540',
        'owner'  => 'root',
        'group'  => 'etcd'
      }) }

      it { should contain_file('/etc/etcd/certs/peer_cert.pem').with({
        'ensure' => 'present',
        'mode'   => '540',
        'owner'  => 'root',
        'group'  => 'etcd'
      }) }

      it { should contain_file('/etc/etcd/certs/peer_key.pem').with({
        'ensure' => 'present',
        'mode'   => '540',
        'owner'  => 'root',
        'group'  => 'etcd'
      }) }

      # etcd::service resources
      it { should contain_service('etcd').with({
          'ensure'   => 'running',
          'enable'   => 'true',
        }) }
    end

    context 'When overriding service parameters' do
      let(:params) { {
          :service_ensure => 'stopped',
          :service_enabled => false } }
      it { should contain_service('etcd').with_ensure('stopped').with_enable('false') }
    end

    context 'When asked not to manage the user' do
      let(:params) { {:manage_user => false } }
      it {
        should_not contain_group('etcd')
        should_not contain_user('etcd')
      }
    end

    context 'When specifying all of the etcd config params' do
      let(:params) { {
          :user                        => 'bob',
          :group                       => 'bob',
          :etcd_name                   => 'default',
          :data_dir                    => '/var/etcd/datadir.etcd',
          :snapshot_count              => '10000',
          :heartbeat_interval          => '100',
          :election_timeout            => '1000',
          :listen_client_urls          => ["https://some.domain:2379","https://some.domain:4001"],
          :max_snapshots               => '5',
          :max_wals                    => '5',
          :cors                        => ['stuff','things'],
          :initial_advertise_peer_urls => ["https://some.domain:2380","https://some.domain:7001"],
          :initial_cluster             => ["default=https://some.domain:2380","default=https://some.domain:7001"],
          :initial_cluster_state       => 'new',
          :initial_cluster_token       => 'etcd-cluster',
          :advertise_client_urls       => ["https://some.domain:2379","https://some.domain:4001"],
          :discovery                   => "https://some.domain",
          :discovery_srv               => "some.domain",
          :discovery_fallback          => 'proxy',
          :discovery_proxy             => "https://some.proxy",
          :proxy                       => 'off',
          :cert_dir                    => '/etc/etcd/certs',
          :ca_file                     => "/etc/etcd/certs/client_ca.pem",
          :ca_file_target              => "/var/lib/puppet/ssl/certs/ca.pem",
          :cert_file                   => "/etc/etcd/certs/client_cert.pem",
          :cert_file_target            => "/var/lib/puppet/ssl/certs/some.domain.pem",
          :key_file                    => "/etc/etcd/certs/client_key.pem",
          :key_file_target             => "/var/lib/puppet/ssl/private_keys/some.domain.pem",
          :client_cert_auth            => true,
          :peer_ca_file                => "/etc/etcd/certs/peer_ca.pem",
          :peer_ca_file_target         => "/var/lib/puppet/ssl/certs/ca.pem",
          :peer_cert_file              => "/etc/etcd/certs/peer_cert.pem",
          :peer_cert_file_target       => "/var/lib/puppet/ssl/certs/some.domain.pem",
          :peer_key_file               => "/etc/etcd/certs/peer_key.pem",
          :peer_key_file_target        => "/var/lib/puppet/ssl/private_keys/some.domain.pem",
          :peer_client_cert_auth       => true,
          :debug                       => false,
          :force_new_cluster           => false,
          :log_package_levels          => ['etcdserver=WARNING'],
          :version                     => false,
        } }
      it { should contain_group('bob').with_ensure('present') }
      it { should contain_user('bob').with_ensure('present').that_requires('Group[bob]') }
      it { should contain_file('/var/etcd/datadir.etcd').with({
          'ensure' =>'directory',
          'owner'  => 'bob',
          'group'  => 'bob',
          'mode'   => '0770' }).that_requires('User[bob]').that_comes_before('Package[etcd]') }
      ## TODO: expand this to for all params
      it { should contain_file('/etc/sysconfig/etcd').with_content(/ETCD_NAME=default/) }
    end
  end
end
