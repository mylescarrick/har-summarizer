#!/usr/bin/env ruby

require 'csv'
require_relative 'filesize'

class BuildHostnameCsv

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
      CSV.open("./reports/#{@filename}-hostnames.csv", "w", :col_sep => "\t") do |csv|
        @csv_rows.each { |r| csv << r }
      end
    rescue Exception => e
      puts "Blew up writing the CSV \n #{e.inspect}"
    end
  end

  def build_hosts
    grouped = @entries.group_by do |entry|
      URI.parse(entry['request']['url']).host
    end

    @csv_rows ||= grouped.inject([]) do |data, (host, entries)|

      sum_filesize = entries.inject(0) { |sum, e| sum + e['response']['_transferSize'] }
      count_resources = entries.size

      data << [
        host,
        human_filesize(sum_filesize),
        count_resources
      ]
      data

    end
  end

end
