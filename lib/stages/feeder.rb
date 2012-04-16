module Stages
  class Feeder < Stage
    def initialize
      @values = []
      super()
    end

    def <<(value)
      @values.push(value)
      reset if done?
    end

    def process
      loop do
        break if @values.empty?
        handle_value @values.shift
      end
    end
  end
end
