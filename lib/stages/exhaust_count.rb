module Stages
  class ExhaustCount < Stage
    def process
      results = 0
      while value = input
        results += 1
      end
      output results
    end
  end
end
