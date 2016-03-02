#shamesly stolen from: https://github.com/puppetlabs/puppetlabs-apache/blob/master/lib/puppet/parser/functions/bool2httpd.rb
#
#Copyright (C) 2012 Puppet Labs Inc
#
#Puppet Labs can be contacted at: info@puppetlabs.com
#
#Licensed under the Apache License, Version 2.0 (the "License");
#
#
Puppet::Parser::Functions::newfunction(:bool2onoff, :type => :rvalue, :doc => <<-EOS
Transform a supposed boolean to On or Off. Pass all other values through.
Given a nil value (undef), bool2onoff will return 'Off'
Example:
    $trace_enable     = false
    $server_signature = 'mail'
    bool2onoff($trace_enable)
    # => 'Off'
    bool2onoff($server_signature)
    # => 'mail'
    bool2onoff(undef)
    # => 'Off'
EOS
) do |args|
  raise(Puppet::ParseError, "bool2onoff() wrong number of arguments. Given: #{args.size} for 1)") if args.size != 1

  arg = args[0]

  if arg.nil? or arg == false or arg =~ /false/i or arg == :undef
    return 'off'
  elsif arg == true or arg =~ /true/i
    return 'on'
  end

  return arg.to_s
end
