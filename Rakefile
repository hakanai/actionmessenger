require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => [ :test ]

# Runs the unit tests
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  t.warning = false
end

# Genereates the RDocs
Rake::RDocTask.new { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "Action Messenger -- instant messaging done simple"
  rdoc.options << '--line-numbers' << '--inline-source' << '-A cattr_accessor=object'
  rdoc.template = "#{ENV['template']}.rb" if ENV['template']
#  rdoc.rdoc_files.include('README', 'CHANGELOG')
  rdoc.rdoc_files.include('lib/action_messenger.rb')
  rdoc.rdoc_files.include('lib/action_messenger/**/*.rb')
}

