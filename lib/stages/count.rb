module Stages
  class Count < Stage
    def input
      result = Hash.new{ |h, k| h[k] = 0 }
      while v = source.run
        if v.is_a? Hash
          v.each_pair{ |key, value| result[key] += value }
        else
          result[v] += 1
        end
      end
      result.empty? ? nil : result
    end
  end
end
