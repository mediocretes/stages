module Stages
  class Cache < Stage
    def initialize()
      super()
    end

    def process
      cache = []
      while i = input
        cache << i
      end
      cache.each{ |x| output x}
    end
  end
end
