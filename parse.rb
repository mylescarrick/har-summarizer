#!/usr/bin/env ruby

require_relative 'lib/parse_hosts'
require_relative 'lib/build_resource_csv'
require_relative 'lib/build_hostname_csv'
require_relative 'lib/build_ip_csv'

filename = ARGV[0]
base_filename = File.basename(filename)

entries = Parser.new.call(filename: filename)

BuildResourceCsv.new.call(entries: entries, filename: base_filename)
BuildHostnameCsv.new.call(entries: entries, filename: base_filename)
BuildIpCsv.new.call(entries: entries, filename: base_filename)
