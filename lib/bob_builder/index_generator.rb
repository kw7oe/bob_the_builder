require 'tempfile'

module BobBuilder
  class IndexGenerator
    def initialize(source_dir)
      @source_dir = source_dir
      @dir_lists = []
      @file_lists = []
    end

    def save
      file = Tempfile.new(['index', '.md'])

      begin
        file.write render(file_lists)
        file.rewind
        system "pandoc -o 'outputs/index.html' '#{file.path}' --css '../pandoc.css'"
      ensure
        file.close
      end
    end

    # Render the index from an array of files
    def render(file_lists)
      previous_parent_dir = nil

      file_lists.map do |f|
        heading = nil
        name = File.basename(f, '.md').gsub("-", " ")
        dirname = File.dirname(f)
        parent_dir = get_parent_dir_name(dirname)

        if (previous_parent_dir != parent_dir)
          previous_parent_dir = parent_dir
          heading = "\n### #{parent_dir}\n"
        end

        "#{heading}- [#{name}](#{f.sub('.md', '.html')})"
      end.join("\n")
    end

    def render_dir(file_lists)
      root_dir = get_root_dir(File.dirname(file_lists.first))
      root_dir_name = capitalize_dirname(root_dir)
      prev_dir = nil

      content = file_lists.map do |f|
        dirname = File.dirname(f)
        parent_dir, index = get_parent_dir(dirname)
        parent_dir_name = get_parent_dir_name(dirname)

        if (index == 2 && prev_dir != parent_dir)
          prev_dir = parent_dir
          "- [#{parent_dir_name}](#{root_dir}/#{parent_dir})"
        else
          nil
        end
      end.compact.join("\n")
      "\n### #{root_dir_name}\n#{content}"
    end

    def file_lists
      return @file_lists unless @file_lists.empty?

      Dir.chdir(@source_dir) do
        Dir.glob("**/*.md") { |x| @file_lists <<  x }
      end

      @file_lists
    end

    # Helper methods
    # TODO: Refactor out of this class
    def capitalize_dirname(dir)
      dir.gsub("-", " ").capitalize
    end

    def get_root_dir(dir)
      dir.split("/").first
    end

    def get_parent_dir(dirname)
      directories = dirname.split(File::SEPARATOR)
      [directories.last, directories.size]
    end

    def get_parent_dir_name(dirname)
      parent_dir, size = get_parent_dir(dirname)
      capitalize_dirname(parent_dir)
    end


  end
end
