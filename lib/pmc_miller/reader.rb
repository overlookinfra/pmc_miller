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
    # @param path [String] File system path to puppet-metrics-collector data
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
        json_string = File.read(f)
        json = JSON.parse(json_string)
        data << PmcMiller::DataPoint.new(json["timestamp"], nested_hash_value(json, key.to_s))
      end
      data
    end

    private

    ##
    # Recursively search through object for key
    #
    # Copied from https://stackoverflow.com/a/8301752
    #
    # @param obj [Object] Object to recursively search
    # @param key [Symbol, string] Key to search for
    #
    # @return First found value associated with key, nil if not found
    #
    def nested_hash_value(obj, key)
      if obj.respond_to?(:key?) && obj.key?(key)
        obj[key]
      elsif obj.respond_to?(:each)
        r = nil
        obj.find { |*a| r = nested_hash_value(a.last, key) }
        r
      end
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
