module Stages
  class Limit < Stage
    def initialize(allowed)
      @allowed = allowed
      @sent = 0
      super()
    end

    def process
      while @sent < @allowed
        handle_value input
        @sent += 1
      end
    end

     def reset
       @sent = 0
       super()
     end
  end
end
