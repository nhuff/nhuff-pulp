require 'rake'
require 'puppet-lint/tasks/puppet-lint'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
  t.rspec_opts = ['--options','spec/spec.opts']
end

task :test => [:spec, :lint]

task :default => :test
