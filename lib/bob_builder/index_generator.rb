require 'tempfile'
require 'fileutils'

module BobBuilder
  class IndexGenerator
    def initialize(source_dir, destination_dir)
      @source_dir = source_dir
      @destination_dir = destination_dir
      @dir_lists = []
      @css_source = File.join(File.dirname(__FILE__), '../../pandoc.css')
    end

    def call
      create_index_file
      generate_html(render_main, "#{@destination_dir}/index.html", @css_source)
    end

    def create_index_file
      dir_lists.each do |dir|
        source_dir = File.join(@source_dir, dir)
        des_dir = File.join(@destination_dir, dir)
        FileUtils.mkdir_p(des_dir)
        content = render_dir(file_lists(source_dir), dir)
        next unless content
        generate_html(content, "#{des_dir}/index.html", @css_source)
      end
    end

    def generate_html(content, destination, css_source)
      file = Tempfile.new(['index', '.md'])
      begin
        file.write(content)
        file.rewind
        command = "pandoc -o '#{destination}' '#{file.path}' --css '#{css_source}'"
        puts(command)
        system(command)
      ensure
        file.close
      end
    end

    def render_main
      render_dir(index_dir, @source_dir, main: true) + "\n" +
      render_files(current_dir_files(@source_dir))
    end

    def current_dir_files(dir)
      files = []
      Dir.chdir(dir) do
        files = Dir.glob('*.md')
      end
      files
    end

    def render_files(files)
      files.map do |file|
        name = File.basename(file, '.md').gsub("-", " ")
        "- [#{name}](#{file.sub('.md', '.html')})"
      end.join("\n")
    end

    # Render the index (Directory and files) from an array of files
    def render_dir(files, dir, main: false)
      return if files.empty?

      root_dir = get_root_dir(dir)
      root_dir_name = if main
                        "Index"
                      else
                        capitalize_dirname(root_dir)
                      end
      prev_dir = nil

      content = files.map do |f|
        dirname = File.dirname(f)

        parent_dir, index = get_parent_dir(dirname)
        parent_dir_name = get_parent_dir_name(dirname)

        if parent_dir == "." && !main
          name = File.basename(f, '.md').gsub("-", " ")
          "- [#{name}](#{f.sub('.md', '.html')})"
        elsif prev_dir != parent_dir
          if main
            "- [#{capitalize_dirname(f)}](#{f}/index.html)"
          else
            prev_dir = parent_dir
            "- [#{parent_dir_name}](#{parent_dir}/index.html)"
          end
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

    def index_dir
      dir_lists.select { |x| x.split(File::SEPARATOR).length == 1 }
    end

    # Helper methods
    # TODO: Refactor out of this class
    def capitalize_dirname(dir)
      dir.gsub(/[_-]/, " ").capitalize
    end

    def get_root_dir(dir)
      dir.split("/").last
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
