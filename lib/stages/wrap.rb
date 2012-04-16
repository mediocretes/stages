module Stages
  class Wrap < Stage
    def initialize(pipeline, *args)
      @feeder = Feeder.new
      @pipeline = @feeder | pipeline
      @output_style = :hash
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
          @output_style == :each ? output(v) : results << v
        end
        results = results.first if @aggregated
        output results if @output_style == :array
        output({ value => results}) if @output_style == :hash
        @pipeline.reset
      end
      @pipeline.reset
    end
  end
end
