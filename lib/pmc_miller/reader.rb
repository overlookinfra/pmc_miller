# frozen_string_literal: true

# PmcMiller
module PmcMiller
  # Reader
  class Reader
    attr_accessor :service
    def initialize(path)
      @path = path
      self.service = nil
    end
  end
end
