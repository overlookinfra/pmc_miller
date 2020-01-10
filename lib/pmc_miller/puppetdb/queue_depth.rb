# frozen_string_literal: true

module PmcMiller
  module PuppetDB
    # QueueDepth analysis class
    class QueueDepth
      attr_reader :data

      def initialize(pmc_reader)
        pmc_reader.service = :puppetdb
        @data = pmc_reader.read(:queue_depth)
        # @rate_of_change
      end

      def rate_of_change
        # simple average of change slope of first half and second half of session.
        (first_half_slope + last_half_slope) / 2
      end

      def first_half_slope
        slope("first", "mid")
      end

      def last_half_slope
        slope("mid", "last")
      end

      def slope(res1, res2)
        unless @data.respond_to?(res1) &&
               @data.respond_to?(res2) &&
               %w[first mid last].include?(res1) &&
               %w[first mid last].include?(res2)
          return
        end

        delta_x = @data.public_send(res2).value - @data.public_send(res1).value
        delta_y = @data.public_send(res2).time - @data.public_send(res1).time
        return delta_x if delta_x.zero?

        delta_y / delta_x
      end

      def settings
        "Unknown"
      end

      def summary
        summary = "pass"
        summary = "fail" if rate_of_change.positive?
        return summary
      end

      def to_json(*)
        "{ 'in': 'progress' }"
      end
    end
  end
end
