module Stages
  class Each < Stage
    def initialize(things = nil, &block)
      @things = things unless things.nil?
      @block = block
      super()
    end

    def process
      if @things
        process_things
      end
      process_inputs
    end

    def process_inputs
      while !source_empty?
        v = input
        v = @block.call(v) if @block
        v.each do |v|
          output v
        end
      end
    end

    def process_things
      @things = @block.call(@things) if @block
      @things.each do |thing|
        handle_value thing
      end
    end
  end
end
