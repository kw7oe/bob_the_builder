require "fileutils"

module BobBuilder
  class Note
    attr_reader :file_name
    def initialize(file, source_dir, destination_dir)
      @file = file
      @source_dir = source_dir
      @destination_dir = destination_dir
      @file_name = File.basename(file)
    end

    def output_file_name
      output_dir = File.dirname(@file).gsub(/#{@source_dir}/, @destination_dir)
      p output_dir
      FileUtils.mkdir_p(output_dir)
      output_file = file_name.split(".")[0] + ".html"
      File.join(output_dir, output_file)
    end

    def render
      system "pandoc -o #{output_file_name} #{@file}"
    end
  end
end
