# frozen_string_literal: true

RSpec.describe 'WorkingTimes::CLI#rest' do
  let(:data_dir) { WorkingTimes::Config.data_dir }
  let(:default_work) { WorkingTimes::Config.default_work }
  let(:last_record) { File.readlines("#{data_dir}/#{default_work}").last.chomp }
  after { FileUtils.rm_rf(WorkingTimes::Config.data_dir) }

  context 'when call without start working' do
    it 'shows "not started" message' do
      msg = "You are not starting work. Execute \"wt start\" to start working.\n"
      expect { WorkingTimes::CLI.new.rest('1h30m') }.to output(msg).to_stdout
    end
  end

  context 'when call without duration' do
    before { WorkingTimes::CLI.new.start }

    it 'shows "specify duration" message' do
      msg = <<~MSG
        Please specify duration of resting.
        e.g. wt rest 1h30m
        e.g. wt rest '1 hour 30 minutes'
      MSG
      expect { WorkingTimes::CLI.new.rest }.to output(msg).to_stdout
    end
  end

  context 'when call with valid duration' do
    before { WorkingTimes::CLI.new.start }

    it 'adds record like "STARTED_AT,FINISHED_AT,,rest"' do
      WorkingTimes::CLI.new.rest('1h30m')
      started_at, finished_at, comment, label = last_record.split(',')
      expect(started_at).not_to be_empty
      expect(finished_at).not_to be_empty
      expect(comment).to be_empty
      expect(label).to eq('rest')
    end

    it 'shows "You can rest until hh:mm:ss." message' do
      msg_regex = /You can rest until \d{2}:\d{2}:\d{2}./
      expect { WorkingTimes::CLI.new.rest('1h30m') }.to output(msg_regex).to_stdout
    end
  end
end
