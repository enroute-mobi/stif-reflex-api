begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/test_app/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

load 'lib/tasks/codifligne_tasks.rake'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

Bundler::GemHelper.install_tasks