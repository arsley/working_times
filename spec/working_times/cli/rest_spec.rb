RSpec.describe 'WorkingTimes::CLI#rest' do
  let(:csv) { CSV.readlines("#{data_dir}/#{default_work}") }
  let(:last_record) { csv.last }
  let(:rest_hour_with_half) { '1h 30m' }
  let(:sec_hour_with_half) { '5400' }
  after { FileUtils.rm_rf(data_dir) }

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

    it 'updates record to \'"STARTED_AT",,"REST_SEC",\'' do
      WorkingTimes::CLI.new.rest(rest_hour_with_half)
      started_at, finished_at, rest_sec, comment = last_record
      expect(started_at).not_to be_empty
      expect(finished_at).to be_empty
      expect(rest_sec).to eq(sec_hour_with_half)
      expect(comment).to be_empty
    end
  end
end
