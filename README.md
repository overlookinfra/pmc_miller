# PmcMiller
[![Build Status](https://travis-ci.com/puppetlabs/pmc_miller.svg?branch=master)](https://travis-ci.com/puppetlabs/pmc_miller)


PmcMiller provides an interface to read and analyze data gathered by
(Puppet Metrics Collector)[https://github.com/puppetlabs/puppetlabs-puppet_metrics_collector].


## Installation

Add this line to your application's Gemfile:

```ruby
gem "pmc_miller"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pmc_miller


## Usage

### Reader

The `PmcMiller::Reader` class can be used to accumulate service data for a
given key.  This provides a ruby object based approach to
[grepping metrics](https://github.com/puppetlabs/puppetlabs-puppet_metrics_collector#grepping-metrics).

The following code snippet initializes the reader object to a specified
`puppet-metrics-collector` path and then accumulates the data for `queue_depth`
associated with the `puppetdb` service.

```ruby
require "pmc_miller/reader"

reader = PmcMiller::Reader.new("/path/to/puppet-metrics-collector")
reader.service = :puppetdb
data = reader.read(:queue_depth)
```

The data object returned is an array of PmcMiller::DataPoint objects.  These
objects are a struct consisting of the `Time` and value of the data point for
the key that was use for the lookup.  From our previous example, the Data
object would appear as follows.

```ruby
puts data    # produces:

#<struct PmcMiller::DataPoint time_string="1970-01-01T00:00:01Z", value=0>
#<struct PmcMiller::DataPoint time_string="1971-01-01T00:00:01Z", value=10>
#<struct PmcMiller::DataPoint time_string="1972-01-01T00:00:01Z", value=20>
```


### Analyzer
PmcMiller contains analyzer classes.  These consume a Data object and return an
object that contains the following methods.

summary
: String of the summary of the analysis (pass/fail).

results
: Hash of calculations created to feed the analysis.

settings
: Hash of configuration settings used to influence the analysis.

to_json
: JSON string of the previous three methods.


```ruby
require "pmc_miller/reader"

reader = PmcMiller::Reader.new("/path/to/puppet-metrics-collector")
reader.service = :puppetdb

data = reader.read(:queue_depth)

qd = PmcMiller::PuppetDB::QueueDepth.new(data)

json = qd.to_json

puts json    #=> {"results":{"rate_of_change":3153600.0},"settings":{},"summary":"fail"}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/puppetlabs/pmc_miller.
