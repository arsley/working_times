# frozen_string_literal: true

require 'fileutils'

RSpec.describe 'WorkingTimes::CLI#finish' do
  let(:csv) { CSV.readlines("#{data_dir}/#{default_work}") }
  let(:last_record) { csv.last }
  after { FileUtils.rm_rf(data_dir) }

  it 'shows "finished" message' do
    WorkingTimes::CLI.new.start # work start
    expect { WorkingTimes::CLI.new.finish }.to output(finish_msg_regexp).to_stdout
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
      expect(File.exist?("#{data_dir}/.working")).to be_falsey
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
      expect(File.exist?("#{data_dir}/.working")).to be_falsey
    end
  end
end
