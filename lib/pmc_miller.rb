# frozen_string_literal: true

require "pmc_miller/version"

module PmcMiller
  autoload :Reader, "pmc_miller/reader"
  autoload :Data, "pmc_miller/data"
  autoload :Queue_depth, "pmc_miller/puppetdb/queue_depth"
  class Error < StandardError; end
  # Your code goes here...
end
