RSpec.describe 'WorkingTimes::CLI#finish' do
  include_context 'CLI#init with cleaning'

  let(:csv) { CSV.readlines(path_current_term) }
  let(:last_record) { csv.last }

  context 'about output message' do
    before { WorkingTimes::CLI.new.start }

    it 'shows "finished" message' do
      expect { WorkingTimes::CLI.new.finish }.to output(finish_msg_regexp).to_stdout
    end

    it 'shows "finished" message' do
      expect { WorkingTimes::CLI.new.finish }.to output(worked_time_regexp).to_stdout
    end
  end

  context 'when call without start working' do
    it 'shows "not started" message' do
      msg = "You are not starting work. Execute \"wt start\" to start working.\n"
      expect { WorkingTimes::CLI.new.finish }.to output(msg).to_stdout
    end
  end

  context 'when call without comment' do
    before do
      WorkingTimes::CLI.new.start
      WorkingTimes::CLI.new.finish
    end

    it 'updates record to \'"STARTED_AT","FINISHED_AT","0",\'' do
      started_at, finished_at, rest_sec, comment = last_record
      expect(started_at).not_to be_empty
      expect(finished_at).not_to be_empty
      expect(rest_sec).to eq('0')
      expect(comment).to be_empty
    end

    it 'deletes data_dir/.working' do
      expect(File.exist?(path_working_flag)).to be_falsey
    end
  end

  context 'when call with comment' do
    before do
      WorkingTimes::CLI.new.start
      WorkingTimes::CLI.new.finish('comment')
    end

    it 'updates record to \'"STARTED_AT","FINISHED_AT","0","COMMENT"\'' do
      started_at, finished_at, rest_sec, comment = last_record
      expect(started_at).not_to be_empty
      expect(finished_at).not_to be_empty
      expect(rest_sec).to eq('0')
      expect(comment).not_to be_empty
    end

    it 'deletes data_dir/.working' do
      expect(File.exist?(path_working_flag)).to be_falsey
    end
  end
end
