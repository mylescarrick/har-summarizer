#!/usr/bin/env ruby

require 'csv'
require 'resolv'
require 'uri'
require_relative 'filesize'

class BuildIpCsv

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
      CSV.open("./reports/#{@filename}-ips.csv", "w", :col_sep => "\t") do |csv|
        @csv_rows.each { |r| csv << r }
      end
    rescue Exception => e
      puts "Blew up writing the CSV \n #{e.inspect}"
    end
  end

  def build_hosts
    grouped = @entries.group_by do |entry|
      URI.parse(entry['request']['url']).host # extract the hostname component
    end

    @csv_rows ||= begin
      csv_rows = []
      grouped.each do |host, entries|

        sum_filesize = entries.inject(0) { |sum, e| sum + e['response']['_transferSize'] }
        count_resources = entries.size

        ips = Resolv.getaddresses(host).sort

        ips.each do |ip|
          csv_rows << [
            ip,
            host,
            human_filesize(sum_filesize),
            count_resources
          ]
        end
      end
      csv_rows
    end
  end

end
