About
------
This puppet module installs and configures etcd.  SSL is enabled by default.

It is designed around the current version of etcd (at time of this writing), 
0.3.0

It is based largely off of the module by Kyle Anderson
https://github.com/solarkennedy/puppet-etcd

Examples
---------
Simplest invocation:

    class { 'etcd': }

  - Installs etcd and etcd rubygem via packages.
  - Manages etcd user and group.
  - Puts data in `/var/etcd/datadir.etcd/`.
  - Exports iptables rules based off of designated url ports.
  - Templates `/etc/sysconfig/etcd`.
  - Manages client and peer certs.  By default, etcd uses Puppet
    certs (/var/lib/puppet/ssl).

Getter and setter methods are provided for keys and values.

  `etcd_cli_set('somekey','someval')`

  - Assigns someval to somekey, on localhost.  Below are other parameters which can be passed.
      - 'host'       => FQDN of the etcd server.
      - 'port'       => Port of the etcd server.
      - 'key'        => Key to set against.
      - 'value'      => Value to set against key.
      - 'test_value' => Value to test before set.
      - 'is_file'    => Boolean, value and (if applicable) testvalue are filepaths?
      - 'ca'         => Server/Client CA. Defaults to puppet CA.
      - 'cert'       => Server/Client x509 cert. Defaults to puppet cert.
      - 'cert_key'   => Server/Client RSA key.  Defaults to puppet cert key.

  `etcd_cli_get('somekey')`

  - Returns the value of 'somekey'.  Below are other parameters which can be passed.
      - 'host'     => FQDN of the etcd server.
      - 'port'     => Port of the etcd server.
      - 'key'      => Key to get against.
      - 'ca'       => Server/Client CA. Defaults to puppet CA.
      - 'cert'     => Server/Client x509 cert. Defaults to puppet cert.
      - 'cert_key' => Server/Client RSA key.  Defaults to puppet cert key.
 
Parameters
----------
See params.pp for all parameters and their defaults.

Requirements
-----------

Contact
-------
Nick Markowski <nmarkowski@keywcorp.com>

Support
-------
