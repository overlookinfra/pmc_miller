# frozen_string_literal: true

require "pmc_miller/data"

# PmcMiller
module PmcMiller
  # Reader
  class Reader
    require "json"

    attr_accessor :service
    def initialize(path)
      @path = path
      @service = nil
    end

    def read(key)
      return unless %i[puppetserver puppetdb].include? @service

      data = PmcMiller::Data.new
      json_files.each do |f|
        host = File.dirname(f).split(File::SEPARATOR).last
        json_string = File.read(f)
        json = JSON.parse(json_string)
        data << PmcMiller::DataPoint.new(json["timestamp"], json.dig(*key_map(key, host)))
      end
      data
    end

    def key_map(key, host)
      key_map = { puppetdb: {
        queue_depth: ["servers",
                      host.gsub(".", "-"),
                      "puppetdb",
                      "puppetdb-status",
                      "status",
                      "queue_depth"]
      } }
      key_map[@service][key]
    end

    def json_files
      Dir[File.join(@path, @service.to_s, "*", "*.json")].sort
    end

    # List of archive files for defined service
    # TODO: Unpack and process the contents of these archives with the json
    # reader.  This archive layout is specified in the
    # [puppet_metrics_collector](https://github.com/puppetlabs/puppetlabs-puppet_metrics_collector#directory-layout)
    def archives
      Dir[File.join(@path, @service.to_s, "*.tar.bz2")]
    end
  end
end
