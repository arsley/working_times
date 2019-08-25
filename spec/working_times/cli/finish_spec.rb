# frozen_string_literal: true

require 'fileutils'

RSpec.describe 'WorkingTimes::CLI#finish' do
  let(:data_dir) { WorkingTimes::Config.data_dir }
  let(:default_work) { WorkingTimes::Config.default_work }
  after { FileUtils.rm_rf(WorkingTimes::Config.data_dir) }

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

    it 'adds record like "finish,,TIMESTAMP"' do
      label, comment, timestamp = File.readlines("#{data_dir}/#{default_work}").last.chomp.split(',')
      expect(label).to eq('finish')
      expect(comment).to be_empty
      expect(timestamp).not_to be_empty
    end

    it 'presents 2 records on working file' do
      expect(File.readlines("#{data_dir}/#{default_work}").size).to eq(2)
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

    it 'adds record like "finish,COMMENT,TIMESTAMP"' do
      label, comment, timestamp = File.readlines("#{data_dir}/#{default_work}").last.chomp.split(',')
      expect(label).to eq('finish')
      expect(comment).not_to be_empty
      expect(timestamp).not_to be_empty
    end

    it 'presents 2 records on working file' do
      expect(File.readlines("#{data_dir}/#{default_work}").size).to eq(2)
    end

    it 'deletes data_dir/.working' do
      expect(File.exist?("#{data_dir}/.working")).to be_falsey
    end
  end
end
