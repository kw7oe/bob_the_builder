# Rake.application.options.trace_rules = true
require 'tempfile'

SOURCE_FILES = Rake::FileList.new("sources/**/*.md",
                                  "sources/**/*.markdown")

task :html => SOURCE_FILES.pathmap("%{^sources/,outputs/}X.html")

directory "outputs"

desc "Open outputs/index.html in browser"
task :show => ['index', 'html'] do
  sh 'open outputs/index.html'
end

desc "Generate template and open the file with vim "
task :generate, [:template_name] do |t, args|
  require 'date'
  mkdir_p "sources"
  date = DateTime.now
  file_name = "sources/#{date.iso8601}_entry.md"

  # Read in template content
  template_name = args[:template_name]
  template = ""
  if template_name
    template = File.read("templates/#{template_name}.md")
  end

  # Write to generated file
  File.open(file_name,"w") do |f|
    f.puts "# #{date.strftime("%F")}"
    f.puts template
  end

  sh "vim #{file_name}"
end

desc "Generate index.html based on sources files"
task :index do
  index = "# Entries\n" + index_md
  file = Tempfile.new(['index', '.md'])
  begin
    file.write index
  ensure
    file.close
    sh "pandoc -o 'outputs/index.html' #{file.path} --css '../pandoc.css'"
  end
end

task :clean do
  rm_rf "outputs"
end

rule '.html' => [->(f){source_for_html(f)}, 'outputs'] do |t|
  mkdir_p t.name.pathmap("%d")
  sh "pandoc -o #{t.name} #{t.source} --css '../pandoc.css'"
end

# ==============
# Helper methods
# ==============

def source_for_html(html_file)
  SOURCE_FILES.detect {|f|
    f.ext('') == html_file.pathmap("%{^outputs/,sources/}X")
  }
end

def index_md
  SOURCE_FILES.pathmap("%{^sources/,outputs/}X.html").map do |s|
    s = s.split("/")[1]
    "- [#{get_date(s)}](#{s})"
  end.join("\n")
end

def get_date(file_name)
  file_name.split("T")[0]
end
