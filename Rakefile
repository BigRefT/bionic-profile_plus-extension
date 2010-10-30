require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    # Bionic only recognizes gems as extensions if they're named according to
    # the bionic-*-extension pattern. Please retain the prefix and suffix.
    gem.name = "bionic-profile_plus-extension"
    gem.summary = %Q{Profile Plus Extension for Bionic CMS}
    gem.description = %Q{Describe your extension here}
    gem.email = "your email"
    gem.homepage = "http://yourwebsite.com/profile_plus"
    gem.authors = ["Your Name"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. This is only required if you plan to package profile_plus as a gem."
end


desc 'Default: run unit tests.'
task :default => :test

desc 'Test the profile_plus extension.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the profile_plus extension.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ProfilePlusExtension'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Load any custom rakefiles for extension
Dir[File.dirname(__FILE__) + '/tasks/*.rake'].sort.each { |f| require f }