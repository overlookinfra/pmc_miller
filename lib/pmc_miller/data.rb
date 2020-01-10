# frozen_string_literal: true

require "time"

module PmcMiller
  # DataPoint object
  DataPoint = Struct.new(:time_string, :value) do
    def time
      Time.iso8601(time_string)
    end
  end

  # Collection of DataPoint objects
  class Data < Array
    # Return the element from the middle of the array.
    def mid
      self[(length / 2)]
    end
  end
end
