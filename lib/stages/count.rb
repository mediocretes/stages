module Stages
  class Count < Stage
    def process
      result = Hash.new{ |h, k| h[k] = 0 }
      while !source_empty?
        v = source.run
        if v.is_a? Hash
          v.each_pair{ |key, value| result[key] += (value || 0) }
        else
          result[v] += 1
        end
      end
      handle_value result
    end
  end
end
