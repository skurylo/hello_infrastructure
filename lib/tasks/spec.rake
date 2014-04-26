require 'rspec/core/rake_task'

desc "Run spec unit and task tests"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--color']
  t.pattern = 'spec/{task,unit}/**/*_spec.rb'
end
