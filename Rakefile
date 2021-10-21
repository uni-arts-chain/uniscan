# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"
require 'rdoc/task'

Rails.application.load_tasks
RDoc::Task.new do |rdoc|
  # rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include("lib/*.rb", "doc/*.rdoc", "app/**/*.rb", "lib/*.rb", "config/**/*.rb")
  rdoc.title = "App Documentation"
  rdoc.options << "--all"
end
