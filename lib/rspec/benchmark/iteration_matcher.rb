# encoding: utf-8

module RSpec
  module Benchmark
    module IterationMatcher
      # Implements the `perform_at_least` matcher
      #
      # @api private
      class Matcher
        def initialize(iterations, options = {})
          @iterations = iterations
        end

        # Indicates this matcher matches against a block
        #
        # @return [True]
        #
        # @api private
        def supports_block_expectations?
          true
        end

        # @return [Boolean]
        #
        # @api private
        def matches?(block)
          @bench = ::Benchmark::Perf::Iteration.new
          @average, @stddev, _ = @bench.run(&block)
          @iterations <= (@average + 3 * @stddev)
        end

        def ips
          self
        end

        def failure_message
          "expected block to #{description}, but #{positive_failure_reason}"
        end

        def failure_message_when_negated
          "expected block not to #{description}, but #{negative_failure_reason}"
        end

        def description
          "perform at least #{@iterations} i/s"
        end

        def actual
          "%d (± %d%%) i/s" % [@average, (@stddev / @average.to_f) * 100]
        end

        def positive_failure_reason
          "performed only #{actual}"
        end

        def negative_failure_reason
          "performed #{actual}"
        end
      end
    end # IterationMatcher
  end # Benchmark
end # RSpec
