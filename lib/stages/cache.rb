module Stages
  class Cache < Stage
    def process
      cache = []
      while !source_empty?
        cache << input
      end
      cache.each{ |x| output x}
    end
  end
end
