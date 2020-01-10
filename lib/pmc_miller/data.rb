# frozen_string_literal: true

require "time"

module PmcMiller
  ##
  # DataPoints are a defined struct containing an iso8601 time and a value.
  #
  # @param time_string [String] Timestamp associated with value
  # @param value [String, Integer, Float] Value of found data
  #
  # @return [PmcMiller::DataPoint] The resulting DataPoint
  #
  DataPoint = Struct.new(:time_string, :value) do
    def time
      Time.iso8601(time_string)
    end
  end

  ##
  # Collection of DataPoint objects
  #
  # @return [PmcMiller::Data] Object to store PmcMiller::DataPoint objects
  #
  class Data < Array
    ##
    # Return the element from the middle of the Data object.
    #
    # @return [PmcMiller::DataPoint]
    #
    def mid
      self[(length / 2)]
    end
  end
end
