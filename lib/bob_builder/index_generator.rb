module BobBuilder
  class IndexGenerator
    def initialize(source_dir)
      @source_dir = source_dir
      @dir_lists = []
      @file_lists = []
    end

    # Render the index from an array of files
    def render(file_lists)
      previous_parent_dir = nil

      file_lists.map do |f|
        heading = nil
        name = File.basename(f, '.md').gsub("-", " ")
        parent_dir = File.dirname(f)
          .split("/")
          .last
          .gsub("-", " ")
          .capitalize

        if (previous_parent_dir != parent_dir)
          previous_parent_dir = parent_dir
          heading = "### #{parent_dir}\n"
        end

        "#{heading}- [#{name}](#{f.sub('.md', '.html')})"
      end.join("\n")
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
