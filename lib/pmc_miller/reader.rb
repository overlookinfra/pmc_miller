# frozen_string_literal: true

require "pmc_miller/datapoint"

# PmcMiller
module PmcMiller
  ##
  # Readers read in puppet-metrics-collector data
  #
  # Readers are associated with a specific puppet-metrics-collector directory.
  # They can then assemble data for a specific service, key combination.
  class Reader
    require "json"

    ##
    # Creates a new reader that will use the given path as its data source.
    #
    # @param path [String] File system path of puppet-metrics-collector root
    #
    # @return [PmcMiller::Reader]
    #
    def initialize(path)
      @path = path
    end

    ##
    # Reads data associated with the given service and key.
    #
    # @param service [String] Service to lookup data for
    # @param key [Symbol] Key to lookup data for
    #
    # @return [PmcMiller::Data] Data collection found
    #
    def read(service, key)
      raise "'#{service}' data unavailable" unless services.include? service

      data = []
      json_files(service).each do |f|
        host = File.dirname(f).split(File::SEPARATOR).last
        raise "no data map for '#{service}::#{key}'" unless key_map(service, key, host)

        json_string = File.read(f)
        json = JSON.parse(json_string)
        data << PmcMiller::DataPoint.new(json["timestamp"], json.dig(*key_map(service, key, host)))
      end
      data
    end

    private

    ##
    # Fully defined data key structure associated with given key.
    #
    # @param service [String] Service to lookup data for
    # @param key [Symbol] Key to look up data structure for
    # @param host [String] Puppet Host associated with data to be found
    #
    # @return [Array] Ordered list of keys needed to dig given key from pmc data
    #
    def key_map(service, key, host)
      key_map = { "puppetdb" => {
        queue_depth: ["servers",
                      host.gsub(".", "-"),
                      "puppetdb",
                      "puppetdb-status",
                      "status",
                      "queue_depth"]
      } }
      key_map[service][key]
    end

    ##
    # Array of service directories found in PMC directory.
    #
    # @return [Array] List of available services
    #
    def services
      Dir.children @path
    end

    ##
    # Sorted array of JSON files for defined service.
    #
    # @param service [String] Service to lookup data for
    #
    # @return [Array] Ordered list of JSON files for defined service
    #
    def json_files(service)
      Dir[File.join(@path, service, "*", "*.json")].sort
    end

    ##
    # Sorted array of archive files for defined service.
    #
    # TODO: Unpack and process the contents of these archives with the json
    # reader.  This archive layout is specified in the
    # [puppet_metrics_collector](https://github.com/puppetlabs/puppetlabs-puppet_metrics_collector#directory-layout)
    #
    # @return [Array] Ordered list of archive files for defined service
    #
    def archives(service)
      Dir[File.join(@path, service, "*.tar.bz2")].sort
    end
  end
end
