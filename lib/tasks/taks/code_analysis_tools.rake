task :code_analysis do
  sh 'bundle exec rails_best_practices .'
  sh 'bundle exec reek app config lib spec'
  sh 'bundle exec rubocop app config lib spec'
  sh 'bundle exec rake jslint'
end
