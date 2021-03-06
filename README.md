# RSpec::Benchmark
[![Gem Version](https://badge.fury.io/rb/rspec-benchmark.svg)][gem]
[![Build Status](https://secure.travis-ci.org/piotrmurach/rspec-benchmark.svg?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/piotrmurach/rspec-benchmark/badges/gpa.svg)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/rspec-benchmark/badge.svg)][coverage]
[![Inline docs](http://inch-ci.org/github/piotrmurach/rspec-benchmark.svg?branch=master)][inchpages]

[gem]: http://badge.fury.io/rb/rspec-benchmark
[travis]: http://travis-ci.org/piotrmurach/rspec-benchmark
[codeclimate]: https://codeclimate.com/github/piotrmurach/rspec-benchmark
[coverage]: https://coveralls.io/github/piotrmurach/rspec-benchmark
[inchpages]: http://inch-ci.org/github/piotrmurach/rspec-benchmark

> Performance testing matchers for RSpec

**RSpec::Benchmark** uses [benchmark-perf](https://github.com/piotrmurach/benchmark-perf) for measurements.

## Why?

Integration and unit tests ensure that changing code maintains expected functionality. What is not guaranteed is the code changes impact on library performance. It is easy to refactor your way out of fast to slow code.

If you are new to performance testing you may find [Caveats](#3-caveats) section helpful.

## Contents

* [1. Usage](#1-usage)
  * [1.1 Execution Time](#11-execution-time)
  * [1.2 Iterations ](#12-iterations)
  * [1.3 Comparison ](#13-comparison)
* [2. Filtering](#2-filtering)
* [3. Caveats](#3-caveats)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-benchmark'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-benchmark

## 1. Usage

For matchers to be available globally, in `spec_helper.rb` do:

```ruby
require 'rspec-benchmark'

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers
end
```

This will add the `perform_under` and `perform_at_least` matchers to express expected performance benchmark from code executed inside the expectation.

Alternatively, you can add matchers for particular example:

```ruby
RSpec.describe "Performance testing" do
  include RSpec::Benchmark::Matchers
end
```

### 1.1 Execution time

The `perform_under` matcher answers the question of how long does it take to perform a given block of code on average. The measurements are taken executing the block of code in a child process for accurent cpu times.

```ruby
expect { ... }.to perform_under(0.01).sec
```

All measurements are assumed to be expressed as seconds. However, you can also provide time in `ms`, `us` and `ns`. The equivalent example in `ms` would be:

```ruby
expect { ... }.to perform_under(10).ms
```

by default the above code will be sampled `30` times but you can change this by using `and_sample` like so:

```ruby
expect { ... }.to perform_under(0.01).and_sample(10)
```

### 1.2 Iterations

The `perform_at_least` matcher allows you to establish performance benchmark of how many iterations per second a given block of code should perform. For example, to expect a given code to perform at least 10K iterations per second do:

```ruby
expect { ... }.to perform_at_least(10000).ips
```

The `ips` part is optional but its usage clarifies the intent.

### 1.3 Comparison

The `perform_faster_than` and `perform_slower_than` matcher allows you to test performance of your code compared to other. For example:

```ruby
expect { ... }.to perform_faster_than { ... }
expect { ... }.to perform_slower_than { ... }
```

And if you want to compare how much faster or slower your code compared to other do:
```ruby
expect { ... }.to perform_faster_than { ... }.in(5).times
expect { ... }.to perform_slower_than { ... }.in(5).times
```

The `times` part is also optional.

## 2 Filtering

Usually performance tests are best left for CI or occasional runs that do not affect TDD/BDD cycle. To achieve isolation you can use RSpec filters. For instance, in `spec_helper`:

```
config.filter_run_excluding performance: true
```

and then in your example group do:

```ruby
RSpec.describe ..., performance: true do
  ...
end
```

Another option is to simply isolate the performance specs in separate directory suc as `spec/performance/...` and add custom rake task.

## 3 Caveats

When writing performance tests things to be mindful are:

+ The tests may **potentially be flaky** thus its best to use sensible boundaries:
  - **too strict** boundaries may cause false positives, making tests fail
  - **too relaxed** boundaries may also lead to false positives missing actual performance regressions
+ Generally performance tests will be **slow**, but you may try to avoid _unnecessarily_ slow tests by choosing smaller maximum value for sampling

If you have any other observations please share them!

## Contributing

1. Fork it ( https://github.com/piotrmurach/rspec-benchmark/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2016-2017 Piotr Murach. See LICENSE for further details.
