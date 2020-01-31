# frozen_string_literal: true

module PmcMiller
  ##
  # Namespace analyzers specific to PuppetDB
  module PuppetDB
    ##
    # Analyze queue_depth data
    class QueueDepth
      attr_reader :data

      ##
      # Creates a new QueueDepth analyzer
      #
      # @param data [Array] queue_depth data to analyze
      #
      # @return [PmcMiller::PuppetDB::QueueDepth]
      #
      def initialize(data)
        # The data set must be sorted by time object from low to high for calculations.
        @data = data.sort_by(&:time)
      end

      ##
      # Calculate rate of change for data.
      #
      # The average rate of change is calculated between the first and second
      # halves of the data set.
      #
      # @return [Float]
      #
      def rate_of_change
        return @_rate_of_change if defined?(@_rate_of_change)

        @_rate_of_change = (first_half_slope + last_half_slope) / 2.0
      end

      ##
      # Calculate slope for the first half of data.
      #
      # The average rate of change (slope) is calculated for the first half of
      # the data set.
      #
      # @return [Float]
      #
      def first_half_slope
        slope(0, @data.length / 2)
      end

      ##
      # Calculate slope for the last half of data.
      #
      # The average rate of change (slope) is calculated for the last half of
      # the data set.
      #
      # @return [Float]
      #
      def last_half_slope
        slope(@data.length / 2, -1)
      end

      ##
      # Calculate slope given points in the data.
      #
      # The average rate of change (slope) is calculated for the given points
      # in the data set.
      #
      # @param dpoint1 [Integer] Array index
      # @param dpoint2 [Integer] Array index
      #
      # @return [Float]
      #
      def slope(dpoint1, dpoint2)
        delta_x = @data[dpoint2].value - @data[dpoint1].value
        delta_y = @data[dpoint2].time - @data[dpoint1].time
        return delta_x if delta_x.zero?

        delta_y / delta_x
      end

      ##
      # Hash of calculations created to feed the analysis.
      #
      # @return [Hash]
      #
      def results
        { rate_of_change: rate_of_change }
      end

      ##
      # Hash of configuration settings used to influence the analysis.
      #
      # @return [Hash]
      #
      def settings
        {}
      end

      ##
      # Summary of the analysis (pass/fail).
      #
      # @return [String]
      #
      def summary
        summary = "pass"
        summary = "fail" if rate_of_change.positive?
        return summary
      end

      ##
      # JSON string of core methods (summary, results, settings).
      #
      # @return [String]
      #
      def to_json(*)
        { results: results, settings: settings, summary: summary }.to_json
      end
    end
  end
end
