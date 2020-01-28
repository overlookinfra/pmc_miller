# frozen_string_literal: true

require "pmc_miller/reader"

fixtures_dir = File.join("spec", "fixtures", "basic", "puppet-metrics-collector")
RSpec.describe PmcMiller::Reader do
  it "allows the setting of the service" do
    reader = PmcMiller::Reader.new(fixtures_dir)
    reader.service = "puppetdb"
    expect(reader.service).to eq("puppetdb")
  end
  it "reads service data for given key" do
    reader = PmcMiller::Reader.new(fixtures_dir)
    reader.service = "puppetdb"
    data = reader.read(:queue_depth)
    expect(data).to be_an_instance_of(Array)
    expect(data[0]).to be_an_instance_of(PmcMiller::DataPoint)
  end
end
