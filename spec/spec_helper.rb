require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rubygems'
require 'spork'
# uncomment the following line to use spork with the debugger
# require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV['RAILS_ENV'] ||= 'test'
  ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'false'

  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  require 'capybara/rspec'
  require 'capybara/rails'
  require 'capybara/poltergeist'
  require 'factory_girl_rails'

  FactoryGirl.factories.clear
  FactoryGirl.reload

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app)
  end

  # The following is a monkey patch to let the capybara server and the test
  # suite share the database connection when using transactional fixtures
  Capybara.javascript_driver = :poltergeist

  # Change rails logger level to reduce IO during tests
  Rails.logger.level = 4

  RSpec.configure do |config|
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.order = 'random'

    config.include FactoryGirl::Syntax::Methods
    config.include Devise::TestHelpers, type: :controller
    config.extend ControllerMacros,     type: :controller
    config.include RequestHelpers

    config.before :each do |example_group|
      if Capybara.current_driver == :rack_test
        DatabaseCleaner.strategy = :transaction
      else
        DatabaseCleaner.strategy = :truncation
      end
      DatabaseCleaner.start
    end

    config.after do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.
