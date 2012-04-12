module Stages
  class Stage
    attr_accessor :source

    def initialize(&block)
      @block = block
      initialize_loop
    end

    def initialize_loop
       @fiber_delegate = Fiber.new do
        process
        die
      end
    end

    def run
      @fiber_delegate.resume
    end

    def reset
      initialize_loop
      @source.reset if @source
    end

    def die
      loop do
        output nil
      end
    end

    def process
      while (value = input) != nil
        handle_value value
      end
    end

    def handle_value(value)
      output value
    end

    def input
      source.nil? ? nil : source.run
    end

    def output(value)
      Fiber.yield value
    end

    def |(other)
      return self if other.nil?
      other.root_source.source = self
      other
    end

    #root_source lets you add to existing pipelines
    #the result is always the rightmost stage
    #so adding things to it is problematic
    def root_source
      source.nil? ? self : source.root_source
    end

    def drop_leftmost!
      if @source.end?
        @source = nil
      else
        @source.drop_leftmost!
      end
    end

    def end?
      @source.nil?
    end

    def length
      if source
        source.length + 1
      else
        1
      end
    end
  end
end

