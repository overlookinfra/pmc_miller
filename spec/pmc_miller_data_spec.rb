# frozen_string_literal: true

require "pmc_miller/data"

RSpec.describe PmcMiller::Data do
  let(:now) { Time.now.iso8601 }
  it "accepts DataPoint object" do
    dp = PmcMiller::DataPoint.new(now, 0)
    data = PmcMiller::Data.new
    data << dp
    expect(data.length).to eq(1)
    expect(data[0]).to eq(dp)
  end
  it "returns the first element" do
    dp0 = PmcMiller::DataPoint.new(now, 0)
    dp1 = PmcMiller::DataPoint.new(now, 1)
    dp2 = PmcMiller::DataPoint.new(now, 2)
    data = PmcMiller::Data.new
    data << dp0 << dp1 << dp2
    expect(data.first).to eq(dp0)
  end
  it "returns the last element" do
    dp0 = PmcMiller::DataPoint.new(now, 0)
    dp1 = PmcMiller::DataPoint.new(now, 1)
    dp2 = PmcMiller::DataPoint.new(now, 2)
    data = PmcMiller::Data.new
    data << dp0 << dp1 << dp2
    expect(data.last).to eq(dp2)
  end
  it "returns the mid element" do
    dp0 = PmcMiller::DataPoint.new(now, 0)
    dp1 = PmcMiller::DataPoint.new(now, 1)
    dp2 = PmcMiller::DataPoint.new(now, 2)
    data = PmcMiller::Data.new
    data << dp0 << dp1 << dp2
    expect(data.mid).to eq(dp1)
  end
end
