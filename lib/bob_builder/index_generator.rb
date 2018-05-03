module BobBuilder
  class IndexGenerator
    def initialize(source_dir)
      @source_dir = source_dir
      @file_lists = []
    end

    def render
    end

    def file_lists
      return @file_lists unless @file_lists.empty?

      Dir.chdir(@source_dir) do
        Dir.glob("**/*.md") { |x| @file_lists <<  x }
      end

      @file_lists
    end

  end
end
