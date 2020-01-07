# frozen_string_literal: true

require "pmc_miller/reader"

FIXTURES_DIR = File.join("spec", "fixtures", "puppet-metrics-collector")
RSpec.describe PmcMiller::Reader do
  it "allows the setting of the service" do
    reader = PmcMiller::Reader.new(FIXTURES_DIR)
    reader.service = :puppetdb
    expect(reader.service).to eq(:puppetdb)
  end
  it "reads service data for given key" do
    reader = PmcMiller::Reader.new(FIXTURES_DIR)
    reader.service = :puppetdb
    results = reader.read(:queue_depth)
    expect(results).to be_an_instance_of(PmcMiller::Results)
  end
end
