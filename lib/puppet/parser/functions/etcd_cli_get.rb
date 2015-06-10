module Puppet::Parser::Functions
  newfunction(:etcd_cli_get, :type => :rvalue, :doc => <<-EOM) do |args|
    This function runs a client against an etcd server and acts as the
    getter for key/value pairs.

    Arguments: key|hash, (host), (port)
      * If a hash is passed as the first argument, the following options are supported:
        - 'host'     => FQDN of the etcd server.
        - 'port'     => Port of the etcd server.
        - 'key'      => Key to get against.
        - 'ca'       => Server/Client CA. Defaults to puppet CA.
        - 'cert'     => Server/Client x509 cert. Defaults to puppet cert.
        - 'cert_key' => Server/Client RSA key.  Defaults to puppet cert key.
      * If a key is passed as the first argument, its value will be returned.
      * If host and port are passed, the client will access the etcd server at that location.
        Defaults to fqdn:4001.
      * Client ssl is enabled by default.  Certs default to Puppet certs (/var/lib/puppet/ssl/).
  EOM

    require 'etcd'

    # Defaults
    host = lookupvar('fqdn')
    ca = '/var/lib/puppet/ssl/certs/ca.pem'
    cert = "/var/lib/puppet/ssl/certs/#{host}.pem"
    cert_key = "/var/lib/puppet/ssl/private_keys/#{host}.pem"
    port = 4001
    key = nil
    retval = nil

    # Parse the args
    if args[0].is_a?(Hash)
      host = args[0]['host'] if args[0]['host']
      port = args[0]['port'] if args[0]['port']
      key = args[0]['key'] if args[0]['key']
      ca = args[0]['ca'] if args[0]['ca']
      cert = args[0]['cert'] if args[0]['cert']
      cert_key = args[0]['cert_key'] if args[0]['cert_key']
    else
      key = args[0]
      host = args[1] if args[1]
      port = args[2] if args[2]
      ca = args[3] if args[3]
      cert = args[4] if args[4]
      cert_key = args[5] if args[5]
    end

    # Check parsed args for errors
    if key.nil? then raise Puppet::ParseError, "You must pass a key." end

    # Format key
    if not key =~ /^\/.*/ then key = '/' + key end

    # Create a client and set values.
    client = Etcd.client(
      :host     => host,
      :port     => port,
      :use_ssl  => true,
      :ca_file  => ca,
      :ssl_cert => OpenSSL::X509::Certificate.new( File.read(cert) ),
      :ssl_key  => OpenSSL::PKey::RSA.new( File.read(cert_key) )
    )
    retval = client.get(key).value

    return retval

  end

end
