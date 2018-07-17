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
      content = content_for_index_file(@source_dir)
      generate_html(content, "#{@destination_dir}/index.html", @css_source)
    end

    def create_index_file
      dir_lists.each do |dir|
        source_dir = File.join(@source_dir, dir)
        des_dir = File.join(@destination_dir, dir)
        FileUtils.mkdir_p(des_dir)
        content = content_for_index_file(source_dir)
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

    def content_for_index_file(dir)
      root = get_root_dir(dir)
      "### #{capitalize_dirname(root)}\n" +
      render_directories(current_dir_directories(dir)) + "\n" +
        render_files(current_dir_files(dir))
    end

    def render_directories(dirs)
      return "" if dirs.empty?
      dirs.map do |dir|
        generate_directory_entry(capitalize_dirname(dir), dir)
      end.join("\n")
    end

    def render_files(files)
      files.map do |file|
        generate_file_entry(file)
      end.join("\n")
    end

    def current_dir_files(dir)
      files = []
      Dir.chdir(dir) do
        files = Dir.glob('*.md')
      end
      files
    end

    def current_dir_directories(dir)
      dirs = Dir.children(dir)
      Dir.chdir(dir) do
        dirs.select! { |x| File.directory?(x) }
      end
      dirs
    end

    def file_lists(dir)
      files = []
      Dir.chdir(dir) do
        files = Dir.glob("**/*.md")
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
    def generate_file_entry(file)
      name = File.basename(file, '.md').gsub("-", " ").capitalize
      "- [#{name}](#{file.sub('.md', '.html')})"
    end

    def generate_directory_entry(title, directory)
      "- [#{title}](#{directory}/index.html)"
    end

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
