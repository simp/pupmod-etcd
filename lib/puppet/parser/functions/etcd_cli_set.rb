module Puppet::Parser::Functions
  newfunction(:etcd_cli_set, :doc => <<-EOM) do |args|
    This function runs a client against an etcd server and acts as the
    setter for key/value pairs.

    Arguments: key|hash, (value), (is_file), (test_value), (host), (port)
      * If a hash is passed as the first argument, the following options are supported:
        - 'host'       => FQDN of the etcd server.
        - 'port'       => Port of the etcd server.
        - 'key'        => Key to set against.
        - 'value'      => Value to set against key.
        - 'test_value' => Value to test before set.
        - 'is_file'    => Boolean, value and (if applicable) testvalue are filepaths?
        - 'ca'         => Server/Client CA. Defaults to puppet CA.
        - 'cert'       => Server/Client x509 cert. Defaults to puppet cert.
        - 'cert_key'   => Server/Client RSA key.  Defaults to puppet cert key.
      * If a key is passed as the first argument, a value must be passed.
      * If is_file is passed, the value and test_value will be treated as filepaths.
      * If a test_value is passed, the client will get the passed keys value and compare to test_value
        before set.
      * If host and port are passed, the client will access the etcd server at that location.
        Defalts to fqdn:4001
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
    value = nil
    test_value = nil
    is_file = false

    # Parse the args
    if args[0].is_a?(Hash)
      host = args[0]['host'] if args[0]['host']
      port = args[0]['port'] if args[0]['port']
      key = args[0]['key'] if args[0]['key']
      value = args[0]['value'] if args[0]['value']
      is_file = args[0]['is_file'] if args[0]['is_file']
      test_value = args[0]['test_value'] if args[0]['test_value']
      ca = args[0]['ca'] if args[0]['ca']
      cert = args[0]['cert'] if args[0]['cert']
      cert_key = args[0]['cert_key'] if args[0]['cert_key']
    else
      key = args[0]
      value = args[1] if args[1]
      is_file = args[2] if args[2]
      test_value = args[3] if args[3]
      host = args[4] if args[4]
      port = args[5] if args[5]
      ca = args[6] if args[6]
      cert = args[7] if args[7]
      cert_key = args[8] if args[8]
    end

    # Check parsed args for errors
    if key.nil? then raise Puppet::ParseError, "You must pass a key." end
    if value.nil? then raise Puppet::ParseError, "You must pass a value." end

    # Format key
    if not key =~ /^\/.*/ then key = '/' + key end

    # Determine value from file contents.
    if is_file then
      if !File.exists?(value) or (not test_value.nil? and !File.exists?(test_value)) then
        raise Puppet::ParseError, "You must pass valid files for value/test_value. Ensure \
files are readable by puppet."
      else
        value = File.read(value)
        if not test_value.nil? then test_value = File.read(test_value) end
      end
    end

    # Create a client and set values.
    client = Etcd.client(
      :host     => host,
      :port     => port,
      :use_ssl  => true,
      :ca_file  => ca,
      :ssl_cert => OpenSSL::X509::Certificate.new( File.read(cert) ),
      :ssl_key  => OpenSSL::PKey::RSA.new( File.read(cert_key) )
    )
    if test_value.nil?
      client.set(key, value: value)
    else
      client.test_and_set(key, value, test_value)
    end

  end

end
