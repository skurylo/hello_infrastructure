Rake::TaskManager.record_task_metadata = true
# Load rake tasks
Dir.glob('lib/tasks/*.rake').each { |r| load r }

task :default do
  Rake::Task.tasks.each { |t| printf("%-10s # %s\n", t.name, t.comment) unless t.comment == nil }
end
