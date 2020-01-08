# frozen_string_literal: true

require "time"

module PmcMiller
  # Result object
  Result = Struct.new(:time_string, :value) do
    def time
      Time.iso8601(time_string)
    end
  end

  # Collection of Result objects
  class Results < Array
    # Return the element from the middle of the array.
    def mid
      self[(length / 2)]
    end
  end
end
