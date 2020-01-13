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
      # @param data [PmcMiller::Data] queue_depth data to analyze
      #
      # @return [PmcMiller::PuppetDB::QueueDepth]
      #
      def initialize(data)
        @data = data
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
        (first_half_slope + last_half_slope) / 2.0
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
        slope("first", "mid")
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
        slope("mid", "last")
      end

      ##
      # Calculate slope given points in the data.
      #
      # The average rate of change (slope) is calculated for the given points
      # in the data set.  The data set must be sorted by time object from low
      # to high.
      #
      # @param dpoint1 [String] Data method name for index (first, mid, last)
      # @param dpoint2 [String] Data method name for index (first, mid, last)
      #
      # @return [Float]
      #
      def slope(dpoint1, dpoint2)
        unless @data.respond_to?(dpoint1) &&
               @data.respond_to?(dpoint2) &&
               %w[first mid last].include?(dpoint1) &&
               %w[first mid last].include?(dpoint2)
          return
        end
        @data = @data.sort_by { |datapoint| datapoint.time }


        delta_x = @data.public_send(dpoint2).value - @data.public_send(dpoint1).value
        delta_y = @data.public_send(dpoint2).time - @data.public_send(dpoint1).time
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
