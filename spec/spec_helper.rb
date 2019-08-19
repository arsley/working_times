require 'bundler/setup'
require 'working_times'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# mock config
# do not remove ACTUAL configurations
module WorkingTimes::Config
  module_function

  def data_dir
    File.expand_path('tmp/.wt')
  end

  def default_work
    'default'
  end
end
