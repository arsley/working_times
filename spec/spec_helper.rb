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

  config.before(:all) do
    # act tmp/ as current directory
    FileUtils.cd('tmp')
  end
end

# to enable helper about paths
include WorkingTimes::Config

# regexp helper for asserting cli output on 'wt start'
def start_msg_regexp
  Regexp.new(WorkingTimes::START_MSG.map { |msg| msg + '|' }.join[0..-2])
end

# regexp helper for asserting cli output on 'wt finish'
def finish_msg_regexp
  Regexp.new(WorkingTimes::FINISH_MSG.map { |msg| msg + '|' }.join[0..-2])
end

def worked_time_regexp
  /You were working about \d{2} hour \d{2} min./
end
