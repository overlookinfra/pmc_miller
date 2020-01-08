# frozen_string_literal: true

require "pmc_miller/results"

RSpec.describe PmcMiller::Results do
  let(:now) { Time.now.iso8601 }
  it "accepts result object" do
    res = PmcMiller::Result.new(now, 0)
    results = PmcMiller::Results.new
    results << res
    expect(results.length).to eq(1)
    expect(results[0]).to eq(res)
  end
  it "returns the first element" do
    res0 = PmcMiller::Result.new(now, 0)
    res1 = PmcMiller::Result.new(now, 1)
    res2 = PmcMiller::Result.new(now, 2)
    results = PmcMiller::Results.new
    results << res0 << res1 << res2
    expect(results.first).to eq(res0)
  end
  it "returns the last element" do
    res0 = PmcMiller::Result.new(now, 0)
    res1 = PmcMiller::Result.new(now, 1)
    res2 = PmcMiller::Result.new(now, 2)
    results = PmcMiller::Results.new
    results << res0 << res1 << res2
    expect(results.last).to eq(res2)
  end
  it "returns the mid element" do
    res0 = PmcMiller::Result.new(now, 0)
    res1 = PmcMiller::Result.new(now, 1)
    res2 = PmcMiller::Result.new(now, 2)
    results = PmcMiller::Results.new
    results << res0 << res1 << res2
    expect(results.mid).to eq(res1)
  end
end
