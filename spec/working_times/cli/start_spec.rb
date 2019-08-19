# frozen_string_literal: true

require 'fileutils'

RSpec.describe 'WorkingTimes::CLI#start' do
  let(:data_dir) { WorkingTimes::Config.data_dir }
  let(:default_work) { WorkingTimes::Config.default_work }
  after { FileUtils.rm_rf(WorkingTimes::Config.data_dir) }

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

    it 'adds record like "start,,TIMESTAMP"' do
      label, comment, timestamp = File.readlines("#{data_dir}/#{default_work}").last.chomp.split(',')
      expect(label).to eq('start')
      expect(comment).to be_empty
      expect(timestamp).not_to be_empty
    end

    it 'creates data_dir/.working to indicate "On working".' do
      expect(File.exist?("#{data_dir}/.working")).to be_truthy
    end
  end

  context 'when call with comment' do
    before { WorkingTimes::CLI.new.start('comment') }

    it 'adds record like "start,COMMENT,TIMESTAMP"' do
      label, comment, timestamp = File.readlines("#{data_dir}/#{default_work}").last.chomp.split(',')
      expect(label).to eq('start')
      expect(comment).not_to be_empty
      expect(timestamp).not_to be_empty
    end

    it 'creates data_dir/.working to indicate "On working".' do
      expect(File.exist?("#{data_dir}/.working")).to be_truthy
    end
  end
end
