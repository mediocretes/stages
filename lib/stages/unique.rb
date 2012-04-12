require 'set'

module Stages
  class Unique < Stage
    def initialize(options = { })
      @prefetch = options[:prefetch]
      super()
    end

    def process
      set = Set.new
      while !source_empty?
        i = input
        added = set.add? i
        handle_value i if added && !@prefetch
      end
      set.each{ |x| handle_value x} if @prefetch
      set = nil
    end
  end
end
