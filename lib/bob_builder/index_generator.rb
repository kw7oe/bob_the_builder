require 'tempfile'
require 'fileutils'

module BobBuilder
  class IndexGenerator
    def initialize(source_dir, destination_dir)
      @source_dir = source_dir
      @destination_dir = destination_dir
      @dir_lists = []
    end

    def create_index_file
      css_source = File.join(File.dirname(__FILE__), '../../pandoc.css')
      p dir_lists

      dir_lists.each do |dir|
        file = Tempfile.new(['index', '.md'])

        begin
          source_dir = File.join(@source_dir, dir)
          des_dir = File.join(@destination_dir, dir)
          FileUtils.mkdir_p(des_dir)

          content = render_dir(file_lists(source_dir))
          next unless content

          file.write(content)
          file.rewind

          command = "pandoc -o '#{des_dir}/index.html' '#{file.path}' --css '#{css_source}'"
          puts(command)
          system(command)
        ensure
          file.close
        end
      end
    end

    # Render the index (Nested files) from an array of files
    def render(files)
      previous_parent_dir = nil

      files.map do |f|
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

    # Render the index (Directory and files) from an array of files
    def render_dir(files)
      return if files.empty?

      root_dir = get_root_dir(File.dirname(files.first))
      root_dir_name = capitalize_dirname(root_dir)
      prev_dir = nil

      content = files.map do |f|
        dirname = File.dirname(f)

        parent_dir, index = get_parent_dir(dirname)
        parent_dir_name = get_parent_dir_name(dirname)

        if parent_dir == "."
          name = File.basename(f, '.md').gsub("-", " ")
          "- [#{name}](#{f.sub('.md', '.html')})"
        elsif prev_dir != parent_dir
          prev_dir = parent_dir
          "- [#{parent_dir_name}](#{parent_dir}/index.html)"
        else
          nil
        end
      end.compact.join("\n")
      "\n### #{root_dir_name}\n#{content}"
    end

    def file_lists(dir)
      files = []
      Dir.chdir(dir) do
        Dir.glob("**/*.md") { |x| files <<  x }
      end

      files
    end

    def dir_lists
      return @dir_lists unless @dir_lists.empty?

      Dir.chdir(@source_dir) do
        Dir.glob("**/*") do |x|
          @dir_lists <<  x if File.directory?(x)
        end
      end

      @dir_lists
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
