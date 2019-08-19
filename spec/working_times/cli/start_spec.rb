# frozen_string_literal: true

RSpec.describe 'WorkingTimes::CLI#start' do
  let(:data_dir) { WorkingTimes::Config.data_dir }
  let(:default_work) { WorkingTimes::Config.default_work }
  after(:context) { `rm -rf #{WorkingTimes::Config.data_dir}` }

  context 'when call first time' do
    before(:context) { WorkingTimes::CLI.new.start }

    it 'creates directory to store WorkingTimes\' data at Config.data_dir' do
      expect(File.exist?(data_dir)).to be_truthy
    end

    it 'creates Config.data_dir/Config.default_work to store working time record' do
      expect(File.exist?("#{data_dir}/#{default_work}")).to be_truthy
    end

    it 'creates Config.data_dir /.working to indicate "On working".' do
      expect(File.exist?("#{data_dir}/.working")).to be_truthy
    end
  end

  context 'when call without comment' do
    before(:context) { WorkingTimes::CLI.new.start }

    it 'adds record like "LABEL,TIME,"' do
      expect(File.readlines("#{data_dir}/#{default_work}").last.chomp.split(',').size).to eq(2)
    end

    it 'creates Config.data_dir /.working to indicate "On working".' do
      expect(File.exist?("#{data_dir}/.working")).to be_truthy
    end
  end

  context 'when call with comment' do
    before(:context) { WorkingTimes::CLI.new.start('comment') }

    it 'adds record like "LABEL,TIME,COMMENT"' do
      expect(File.readlines("#{data_dir}/#{default_work}").last.chomp.split(',').size).to eq(3)
    end

    it 'creates Config.data_dir /.working to indicate "On working".' do
      expect(File.exist?("#{data_dir}/.working")).to be_truthy
    end
  end
end
