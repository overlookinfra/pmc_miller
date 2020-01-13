# frozen_string_literal: true

require "pmc_miller/data"

# PmcMiller
module PmcMiller
  ##
  # Readers read in puppet-metrics-collector data
  #
  # Readers are associated with a specific puppet-metrics-collector directory.
  # They can then assemble data for a specific key after they have been
  # associated with the desired service.
  class Reader
    require "json"

    attr_accessor :service

    ##
    # Creates a new reader that will use the given path as its data source.
    #
    # @param path [String] File system path of puppet-metrics-collector root
    #
    # @return [PmcMiller::Reader]
    #
    def initialize(path)
      @path = path
      @service = nil
    end

    ##
    # Reads data associated with the given key for the assigned service of the
    # reader.
    #
    # @param key [Symbol] Key to lookup data for
    #
    # @return [PmcMiller::Data] Data collection found
    #
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

    private

    ##
    # Fully defined data key structure assocated with given key.
    #
    # @param key [Symbol] Key to look up data structure for
    # @param host [String] Puppet Host associated with data to be found
    #
    # @return [Array] Ordered list of keys needed to dig given key from pmc data
    #
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

    ##
    # Sorted array of JSON files for defined service.
    #
    # @return [Array] Ordered list of JSON files for defined service
    #
    def json_files
      Dir[File.join(@path, @service.to_s, "*", "*.json")].sort
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
    def archives
      Dir[File.join(@path, @service.to_s, "*.tar.bz2")].sort
    end
  end
end
