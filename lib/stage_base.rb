module Stages
  class Stage
    attr_accessor :source

    def initialize(&block)
      @block = block
      initialize_loop
    end

    def initialize_loop
      @done = false
      @cached_value = :stages_empty_cache
      @fiber_delegate = Fiber.new do
        process
        @done = true
        die
      end
    end

    def run
      if @cached_value != :stages_empty_cache
        v = @cached_value
        @cached_value = :stages_empty_cache
        return v
      end
      @fiber_delegate.resume
    end

    def done?
      return true if @done
      return false if @cached_value != :stages_empty_cache
      next_value = @fiber_delegate.resume
      if next_value == :stages_eos
        @done = true
        @cached_value = :stages_empty_cache
        return true
      end
      @cached_value = next_value
      return false
    end

    def reset
      initialize_loop
      @source.reset if @source
    end

    def die
      loop do
        output :stages_eos
      end
    end

    def process
      while !source_empty?
        handle_value input
      end
    end

    def to_enum
      Enumerator.new do |y|
        while !done?
          y << run
        end
      end
    end

    def handle_value(value)
      output value
    end

    def source_empty?
      (source.nil? || source.done?)
    end

    def input
      source.nil? ? :stages_eos : source.run
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

