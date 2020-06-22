#!/usr/bin/env ruby

require 'json'

class Parser

  def call(filename:)
    @filename = filename
    @json_entries = parse_har
    puts "Found #{ @json_entries.size } total entries in the HAR file"
    @json_entries
  end


  private

  def parse_har
    begin
      json = JSON.parse(File.read(@filename))
      @json_entries = json['log']['entries']
    rescue Exception => e
      puts "Blew up reading or parsing the file. Perhaps you forgot to specify one? \n #{e.inspect}"
    end
  end

end