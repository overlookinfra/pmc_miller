# frozen_string_literal: true

require "pmc_miller/reader"

fixtures_dir = File.join("spec", "fixtures", "basic", "puppet-metrics-collector")
RSpec.describe PmcMiller::Reader do
  it "reads service data for given key" do
    reader = PmcMiller::Reader.new(fixtures_dir)
    data = reader.read("puppetdb", "queue_depth")
    expect(data).to be_an_instance_of(Array)
    expect(data[0]).to be_an_instance_of(PmcMiller::DataPoint)
  end
  it "raises an error when the given service is not available" do
    reader = PmcMiller::Reader.new(fixtures_dir)
    expect { reader.read("foobar", "queue_depth") }.to raise_error(RuntimeError, "'foobar' data unavailable")
  end
  it "raises an error when the given service, key is not available" do
    reader = PmcMiller::Reader.new(fixtures_dir)
    expect { reader.read("puppetdb", :foobar) }.to raise_error(RuntimeError, "no data map for 'puppetdb::foobar'")
  end
end
