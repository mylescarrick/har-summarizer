#!/usr/bin/env ruby

require 'csv'
require_relative 'filesize'

class BuildResourceCsv

  include Filesize

  def call(entries:, filename:)
    @entries = entries
    @filename = filename
    write_csv
  end


  private

  def write_csv
    begin
      build_hosts
      CSV.open("./reports/#{@filename}-resources.csv", "w", :col_sep => "\t") do |csv|
        @csv_rows.each { |r| csv << r }
      end
    rescue Exception => e
      puts "Blew up writing the CSV \n #{e.inspect}"
    end
  end

  def build_hosts
    @csv_rows ||= @entries.inject([]) do |data, entry|
      uri = URI.parse(entry['request']['url'])
      # puts "#{ uri.scheme }|#{ uri.host }|#{ uri.path }"

      http_version = entry['response']['httpVersion']
      bytes = entry['response']['_transferSize']
      resource_type = entry['_resourceType']

      data << [
        resource_type,
        uri.scheme,
        http_version,
        uri.host,
        uri.path,
        human_filesize(bytes),
        uri.query
      ]
      data

    end
  end

  # HT https://stackoverflow.com/questions/16026048/pretty-file-size-in-ruby
  def filesize(size)
    units = ['B', 'KiB', 'MiB', 'GiB', 'TiB', 'Pib', 'EiB']

    return '0.0 B' if size == 0
    exp = (Math.log(size) / Math.log(1024)).to_i
    exp += 1 if (size.to_f / 1024 ** exp >= 1024 - 0.05)
    exp = 6 if exp > 6

    '%.1f %s' % [size.to_f / 1024 ** exp, units[exp]]
  end

end
