# frozen_string_literal: true

require "pmc_miller/datapoint"

RSpec.describe PmcMiller::DataPoint do
  let(:now) { Time.now.iso8601 }
  it "returns value" do
    dp = PmcMiller::DataPoint.new(now, 0)
    expect(dp.value).to eq(0)
  end
  it "returns time" do
    dp = PmcMiller::DataPoint.new(now, 0)
    expect(dp.time).to eq(Time.iso8601(now))
  end
end
