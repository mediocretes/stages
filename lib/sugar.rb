module Stages
  module Sugar
    def select(*args, &block)
      Select.new(*args, &block)
    end

    def each(*args, &block)
      Each.new(*args, &block)
    end

    def map(*args, &block)
      Map.new(*args, &block)
    end

    def wrap(*args, &block)
      Wrap.new(*args, &block)
    end

    def unique(*args, &block)
      Unique.new(*args, &block)
    end

    def run_until_exhausted(*args, &block)
      Exhaust.new(*args, &block)
    end

    def exhaust_and_count(*args, &block)
      ExhaustCount.new(*args, &block)
    end

    def group(*args, &block)
      Count.new
    end

    def emit(*args, &block)
      Emit.new(*args, &block)
    end

    def cache(*args, &block)
      Cache.new(*args, &block)
    end

    def feeder(*args, &block)
      Feeder.new(*args, &block)
    end
  end
end
