require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require File.dirname(__FILE__) + '/lib/action_messenger/version'

PKG_NAME    = 'actionmessenger'
PKG_VERSION = ActionMessenger::VERSION::STRING

task :default => [ :test ]

# Runs the unit tests
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  t.warning = false
end

# Genereates the RDocs
Rake::RDocTask.new { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Action Messenger -- instant messaging made simple'
  rdoc.options << '--line-numbers' << '--inline-source' << '-A cattr_accessor=object'
  rdoc.template = "#{ENV['template']}.rb" if ENV['template']
  rdoc.rdoc_files.include('README', 'COPYING')
  rdoc.rdoc_files.include('lib/action_messenger.rb')
  rdoc.rdoc_files.include('lib/action_messenger/**/*.rb')
}

# Creates the package
spec = Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY
  spec.name = PKG_NAME
  spec.summary = 'Simple, testable XMPP instant messaging'
  spec.description = 'Makes it trivial to test and deliver instant messages.'
  spec.version = PKG_VERSION

  spec.author = 'Trejkaz'
  spec.email = 'trejkaz@trypticon.org'
  spec.homepage = 'http://trypticon.org/software/actionmessenger/'

  spec.has_rdoc = true
  spec.requirements << 'none'
  spec.require_path = 'lib'
  spec.autorequire = 'action_messenger'

  svnfiles = proc { |item| item.include?('\.svn') }

  spec.files = [ 'README', 'COPYING', 'Rakefile' ] +
               ( Dir.glob('lib/**/*') +
                 Dir.glob('test/**/*') +
                 Dir.glob('vendor/**/*') ).delete_if { |item| item.include?('\.svn') }
end
Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

