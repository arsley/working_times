RSpec.describe 'WorkingTimes::CLI#rest' do
  include_context 'CLI#init with cleaning'

  let(:csv) { CSV.readlines(path_current_term) }
  let(:last_record) { csv.last }
  let(:rest_hour_with_half) { '1h 30m' }
  let(:sec_hour_with_half) { '5400' }

  context 'when call without start working' do
    it 'shows "not started" message' do
      msg = "You are not starting work. Execute \"wt start\" to start working.\n"
      expect { WorkingTimes::CLI.new.rest('1h30m') }.to output(msg).to_stdout
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
