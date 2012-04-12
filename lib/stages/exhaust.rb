module Stages
  class Exhaust < Stage
    def process
      results = []
      while !source_empty?
        results << input
      end
      output results
    end
  end
end
