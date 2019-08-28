# frozen_string_literal: true

require 'fileutils'

RSpec.describe 'WorkingTimes::CLI#start' do
  let(:last_record) { File.readlines("#{data_dir}/#{default_work}").last.chomp }
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
  end

  context 'when call without comment' do
    before { WorkingTimes::CLI.new.start }

    it 'adds record like "STARTED_AT,,,start"' do
      started_at, finished_at, comment, label = last_record.split(',')
      expect(started_at).not_to be_empty
      expect(finished_at).to be_empty
      expect(comment).to be_empty
      expect(label).to eq('start')
    end

    it 'creates data_dir/.working to indicate "On working".' do
      expect(File.exist?("#{data_dir}/.working")).to be_truthy
    end
  end

  context 'when call with comment' do
    before { WorkingTimes::CLI.new.start('comment') }

    it 'adds record like "STARTED_AT,,COMMENT,start"' do
      started_at, finished_at, comment, label = last_record.split(',')
      expect(started_at).not_to be_empty
      expect(finished_at).to be_empty
      expect(comment).not_to be_empty
      expect(label).to eq('start')
    end

    it 'creates data_dir/.working to indicate "On working".' do
      expect(File.exist?("#{data_dir}/.working")).to be_truthy
    end
  end
end
