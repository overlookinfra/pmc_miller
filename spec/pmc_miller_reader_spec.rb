# frozen_string_literal: true

require "pmc_miller/reader"

FIXTURES_DIR = "spec/fixtures"
RSpec.describe PmcMiller::Reader do
  it "allows the setting of the service" do
    reader = PmcMiller::Reader.new(FIXTURES_DIR)
    reader.service = :puppetdb
    expect(reader.service).to eq(:puppetdb)
  end
end
