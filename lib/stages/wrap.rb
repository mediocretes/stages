module Stages
  class Wrap < Stage

    #pass a block that takes two arguments that joins the original thing passed to the results, for each result

    def initialize(pipeline, *args, &block)
      @feeder = Feeder.new
      @pipeline = @feeder | pipeline
      @output_style = :hash
      @block = block
      unless args.empty?
        if args.include? :array
          @output_style = :array
        elsif args.include? :each
          @output_style = :each
        end
        @aggregated = true if args.include? :aggregated
      end
      super()
    end

    def reset
      initialize_loop
      @pipeline.reset
      @source.reset if @source
    end

    def process
      while !source_empty?
        value = input
        @feeder << value
        results = []
        while !@pipeline.done?
          v = @pipeline.run
          #yield each subpipeline result, as they are generated
          if @output_style == :each
            if @block
              output @block.call(value, v)
            else
              output v
            end
          else
            results << v
          end
        end
        if @output_style != :each
          results = results.first if @aggregated
          #note that block supercedes array or hash
          if @block
            output @block.call(value, results)
          else
            output results if @output_style == :array
            output({ value => results}) if @output_style == :hash
          end
        end
        @pipeline.reset
      end
      @pipeline.reset
    end
  end
end
