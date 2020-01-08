# frozen_string_literal: true

require "pmc_miller/reader"
require "pmc_miller/puppetdb/queue_depth"

require "pry"
RSpec.describe PmcMiller::PuppetDB::QueueDepth do
  context "Minimal queue depth info" do
    fixtures_dir = File.join("spec", "fixtures", "basic", "puppet-metrics-collector")
    reader = PmcMiller::Reader.new(fixtures_dir)
    subject = PmcMiller::PuppetDB::QueueDepth.new(reader)

    it "gathers results of puppetdb queue depth" do
      # expected valuesextracted from fixture json file
      expected_result = PmcMiller::Result.new("1970-01-01T00:00:01Z", 0)
      expected_results = PmcMiller::Results.new
      expected_results << expected_result
      expect(subject.results).to eq(expected_results)
    end

    it "gathers settings of puppetdb queue depth" do
      expect(subject.settings).to eq("Unknown")
    end

    it "constructs summary of puppetdb queue depth" do
      expect(subject.summary).to eq("pass")
    end

    it "emits json of puppetdb queue depth" do
      expect(subject.to_json).to eq("{ 'in': 'progress' }")
    end
  end

  context "When queue depth is increasing in the second half" do
    fixtures_dir = File.join("spec", "fixtures", "failing", "puppet-metrics-collector")
    reader = PmcMiller::Reader.new(fixtures_dir)
    subject = PmcMiller::PuppetDB::QueueDepth.new(reader)
    it "fails" do
      expect(subject.summary).to eq("fail")
    end
  end
  context "When queue depth is decreasing in the second half" do
    fixtures_dir = File.join("spec", "fixtures", "passing", "puppet-metrics-collector")
    reader = PmcMiller::Reader.new(fixtures_dir)
    subject = PmcMiller::PuppetDB::QueueDepth.new(reader)
    it "passes" do
      expect(subject.summary).to eq("pass")
    end
  end
end
