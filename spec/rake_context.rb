require 'rake'
shared_context 'rake' do
  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { "lib/tasks/#{task_name.split(":").first}" }
  subject         { rake[task_name] }

  def loaded_files_excluding_current_rake_file
    $".reject {|file| file == "#{Rake.application.find_rakefile_location[1]}/#{task_path}.rake" }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [ Rake.application.find_rakefile_location[1] ], loaded_files_excluding_current_rake_file)
  end
end

