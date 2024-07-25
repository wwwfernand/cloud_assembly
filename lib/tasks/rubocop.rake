require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-rails'
  task.requires << 'rubocop-capybara'
  task.requires << 'rubocop-rspec'
  task.requires << 'rubocop-factory_bot'
end
