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

  # disable STDERR, STDOUT during examples run
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:all) do
    $stderr = File.open(File::NULL, 'w')
    $stdout = File.open(File::NULL, 'w')
  end
  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end

# mock config
# do not remove ACTUAL configurations
module WorkingTimes::Config
  private

  def data_dir
    File.expand_path('tmp/.wt')
  end

  def default_work
    'default'
  end
end

# directory helper for spec
def data_dir
  File.expand_path('tmp/.wt')
end

def default_work
  'default'
end

# regexp helper for asserting cli output on 'wt start'
def start_msg_regexp
  Regexp.new(WorkingTimes::START_MSG.map { |msg| msg + '|' }.join[0..-2])
end

# regexp helper for asserting cli output on 'wt finish'
def finish_msg_regexp
  Regexp.new(WorkingTimes::FINISH_MSG.map { |msg| msg + '|' }.join[0..-2])
end
