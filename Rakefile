require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec
rescue LoadError
end

desc 'Run example scripts'
task :examples do
  example_files = FileList['./examples/*.rb']
  example_files.each do |file|
    puts "Loading #{file}"
    puts '*' * 80
    require file
  end
end
