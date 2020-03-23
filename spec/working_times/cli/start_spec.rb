# frozen_string_literal: true

require 'fileutils'

RSpec.describe 'WorkingTimes::CLI#start' do
  let(:csv) { CSV.readlines("#{data_dir}/#{default_work}") }
  let(:header) { csv.first }
  let(:last_record) { csv.last }
  after { FileUtils.rm_rf(data_dir) }

  it 'shows "started" message' do
    expect { WorkingTimes::CLI.new.start }.to output(start_msg_regexp).to_stdout
  end

  context 'when work is already started' do
    before { WorkingTimes::CLI.new.start }

    it 'shows "already started" and "how to finish" message' do
      msg = <<~MSG
        You are already on working at default.
        To finish this, execute 'wt finish'.
      MSG
      expect { WorkingTimes::CLI.new.start }.to output(msg).to_stdout
    end
  end

  context 'when call first time' do
    before { WorkingTimes::CLI.new.start }

    it 'creates directory to store WorkingTimes\' data at data_dir' do
      expect(File.exist?(data_dir)).to be_truthy
    end

    it 'creates data_dir/default_work to store working time record' do
      expect(File.exist?("#{data_dir}/#{default_work}")).to be_truthy
    end

    it 'creates data_dir/.working to indicate "On working".' do
      expect(File.exist?("#{data_dir}/.working")).to be_truthy
    end

    it 'includes header like \'started_at,finished_at,rest_sec,comment\' on data_dir/default_work' do
      expect(header[0]).to eq('started_at')
      expect(header[1]).to eq('finished_at')
      expect(header[2]).to eq('rest_sec')
      expect(header[3]).to eq('comment')
    end
  end

  context 'when call without comment' do
    before { WorkingTimes::CLI.new.start }

    it 'adds record like \'"STARTED_AT",,"0",\'' do
      started_at, finished_at, rest_sec, comment = last_record
      expect(started_at).not_to be_empty
      expect(finished_at).to be_empty
      expect(rest_sec).to eq('0')
      expect(comment).to be_empty
    end

    it 'creates data_dir/.working to indicate "On working".' do
      expect(File.exist?("#{data_dir}/.working")).to be_truthy
    end
  end

  context 'when call with comment' do
    before { WorkingTimes::CLI.new.start('comment') }

    it 'adds record like \'"STARTED_AT",,"0","COMMENT"\'' do
      started_at, finished_at, rest_sec, comment = last_record
      expect(started_at).not_to be_empty
      expect(finished_at).to be_empty
      expect(rest_sec).to eq('0')
      expect(comment).not_to be_empty
    end

    it 'creates data_dir/.working to indicate "On working".' do
      expect(File.exist?("#{data_dir}/.working")).to be_truthy
    end
  end
end
