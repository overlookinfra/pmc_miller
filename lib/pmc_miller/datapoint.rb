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
end
