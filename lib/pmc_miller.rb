# frozen_string_literal: true

require "pmc_miller/version"

# PmcMiller
module PmcMiller
  autoload :Reader, "pmc_miller/reader"
  autoload :DataPoint, "pmc_miller/datapoint"
  autoload :Queue_depth, "pmc_miller/puppetdb/queue_depth"
  class Error < StandardError; end
  # Your code goes here...
end
