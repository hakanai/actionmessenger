require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/contrib/sshpublisher'
require File.dirname(__FILE__) + '/lib/action_messenger/version'

PKG_NAME      = 'actionmessenger'
PKG_VERSION   = ActionMessenger::VERSION::STRING
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

PUBLISH_LOGIN = 'trejkaz@trypticon.org'
PUBLISH_DIR = 'wwwroot/branches/software/actionmessenger'

task :default => [ :test ]

# Runs the unit tests
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  t.warning = false
end

desc "Run tests with code coverage"
task :coverage do
  sh "rcov --exclude vendor/xmpp4r " + Rake::FileList['test/**/*_test.rb'].join(' ')
end
desc "Remove coverage products"
task :clobber_coverage do
  rm_r 'coverage' rescue nil
end
task :clobber => [ :clobber_coverage ]

# Genereates the RDocs
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Action Messenger -- instant messaging made simple'
  rdoc.options << '--line-numbers' << '--inline-source' << '-A cattr_accessor=object'
  rdoc.template = "#{ENV['template']}.rb" if ENV['template']
  rdoc.rdoc_files.include('README', 'CHANGES', 'COPYING')
  rdoc.rdoc_files.include('lib/action_messenger.rb')
  rdoc.rdoc_files.include('lib/action_messenger/**/*.rb')
end

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

  spec.files = [ 'README', 'CHANGES', 'COPYING', 'Rakefile' ] +
               ( Dir.glob('lib/**/*') +
                 Dir.glob('test/**/*') +
                 Dir.glob('vendor/**/*') ).delete_if { |item| item.include?('\.svn') }
end
Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
  package.need_tar = true
end

desc "Publish the rdoc documentation"
task :publish_rdoc => [:rdoc] do
  Rake::SshDirPublisher.new(PUBLISH_LOGIN, PUBLISH_DIR + '/doc', 'doc').upload
  Rake::SshFilePublisher.new(PUBLISH_LOGIN, PUBLISH_DIR + '/doc', 'data/webfiles', '.htaccess').upload
end

desc "Publish the software packages"
task :publish_package => [:package] do
  Rake::SshFilePublisher.new(PUBLISH_LOGIN, PUBLISH_DIR, 'pkg', "#{PKG_FILE_NAME}.gem").upload
  Rake::SshFilePublisher.new(PUBLISH_LOGIN, PUBLISH_DIR, 'pkg', "#{PKG_FILE_NAME}.tgz").upload
end

desc "Publish the coverage reports"
task :publish_coverage => [:coverage] do
  Rake::SshDirPublisher.new(PUBLISH_LOGIN, PUBLISH_DIR + '/coverage', 'coverage').upload
  Rake::SshFilePublisher.new(PUBLISH_LOGIN, PUBLISH_DIR + '/coverage', 'data/webfiles', '.htaccess').upload
end

task :publish => [:publish_rdoc, :publish_package]
