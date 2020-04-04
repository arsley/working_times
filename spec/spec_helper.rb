require 'bundler/setup'
require 'working_times'

TMP_DIR = File.expand_path('tmp').freeze

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # disable STDERR, STDOUT during examples run when pry is not loaded
  original_stderr = $stderr
  original_stdout = $stdout

  config.before(:all) do
    # act tmp/ as current directory
    FileUtils.cd(TMP_DIR)

    unless respond_to? :pry
      $stderr = File.open(File::NULL, 'w')
      $stdout = File.open(File::NULL, 'w')
    end
  end

  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end

# to enable helper about paths
include WorkingTimes::Config

RSpec.shared_context 'CLI#init with cleaning' do
  let(:workon) { 'test_workon' }
  let(:term) { 'test_term_1st' }
  let(:company) { 'test_company' }

  before do
    WorkingTimes::CLI.new.init(workon, term, company)
    FileUtils.cd(workon)
  end

  after do
    FileUtils.cd('../')
    FileUtils.rm_rf(workon)
  end
end

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
