module Tags
  RUBY_FILES = FileList['**/*.rb', "vendor/plugins/db-charmer/**/*.rb"].exclude('pkg')
end

task :tags => Tags::RUBY_FILES do
  puts "Generating TAGS file..."
  sh "/opt/local/bin/ctags #{Tags::RUBY_FILES}", :verbose => false
end
