# frozen_string_literal: true

require "pmc_miller/reader"
require "pmc_miller/puppetdb/queue_depth"

# rubocop:disable Metrics/BlockLength
RSpec.describe PmcMiller::PuppetDB::QueueDepth do
  context "Minimal queue depth info" do
    fixtures_dir = File.join("spec", "fixtures", "basic", "puppet-metrics-collector")
    reader = PmcMiller::Reader.new(fixtures_dir)
    reader.service = :puppetdb
    data = reader.read(:queue_depth)
    subject = PmcMiller::PuppetDB::QueueDepth.new(data)

    it "gathers data of puppetdb queue depth" do
      # expected values extracted from fixture json file
      expected_data_point = PmcMiller::DataPoint.new("1970-01-01T00:00:01Z", 0)
      expected_data = []
      expected_data << expected_data_point
      expect(subject.data).to eq(expected_data)
    end

    it "gathers settings of puppetdb queue depth" do
      expect(subject.settings).to eq({})
    end

    it "gathers the analysis results of puppetdb queue depth" do
      expect(subject.results).to eq(rate_of_change: 0.0)
    end

    it "constructs summary of puppetdb queue depth" do
      expect(subject.summary).to eq("pass")
    end

    it "emits json of puppetdb queue depth" do
      expect(subject.to_json).to eq('{"results":{"rate_of_change":0.0},"settings":{},"summary":"pass"}')
    end
  end

  context "When queue depth is increasing in the second half" do
    fixtures_dir = File.join("spec", "fixtures", "failing", "puppet-metrics-collector")
    reader = PmcMiller::Reader.new(fixtures_dir)
    reader.service = :puppetdb
    data = reader.read(:queue_depth)
    subject = PmcMiller::PuppetDB::QueueDepth.new(data)
    it "fails" do
      expect(subject.summary).to eq("fail")
    end
    it "has a positive rate of change" do
      res = subject.results
      expect(res).to include(:rate_of_change)
      expect(res[:rate_of_change]).to be > 0.0
    end
  end
  context "When queue depth is decreasing in the second half" do
    fixtures_dir = File.join("spec", "fixtures", "passing", "puppet-metrics-collector")
    reader = PmcMiller::Reader.new(fixtures_dir)
    reader.service = :puppetdb
    data = reader.read(:queue_depth)
    subject = PmcMiller::PuppetDB::QueueDepth.new(data)
    it "passes" do
      expect(subject.summary).to eq("pass")
    end
    it "has a non-positive rate of change" do
      res = subject.results
      expect(res).to include(:rate_of_change)
      expect(res[:rate_of_change]).to be <= 0.0
    end
  end
end
# rubocop:enable Metrics/BlockLength
