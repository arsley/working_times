# frozen_string_literal: true

RSpec.describe 'WorkingTimes::CLI#start' do
  before(:context) { WorkingTimes::CLI.new.start }
  after(:context)  { `rm -rf ~/.wt` } # temporary method for clean up

  context 'when call first time' do
    it 'creates directory to store WorkingTimes\' data at ~/.wt' do
      expect(File.exist?(File.expand_path('~/.wt'))).to be_truthy
    end

    it 'creates ~/.wt/default to store working time record' do
      expect(File.exist?(File.expand_path('~/.wt/default'))).to be_truthy
    end

    it 'creates ~/.wt/.working to indicate "On working". It must be deleted on "finish"' do
      expect(File.exist?(File.expand_path('~/.wt/.working'))).to be_truthy
    end
  end

  context 'when call without comment' do
    it 'adds record like "LABEL,TIME,"' do
      expect(`tail -n 1 ~/.wt/default`.chomp.split(',').size).to eq(2)
    end

    it 'creates ~/.wt/.working to indicate "On working". It must be deleted on "finish"' do
      expect(File.exist?(File.expand_path('~/.wt/.working'))).to be_truthy
    end
  end

  context 'when call with comment' do
    it 'adds record like "LABEL,TIME,COMMENT"' do
      expect(`tail -n 1 ~/.wt/default`.chomp.split(',').size).to eq(3)
    end

    it 'creates ~/.wt/.working to indicate "On working". It must be deleted on "finish"' do
      expect(File.exist?(File.expand_path('~/.wt/.working'))).to be_truthy
    end
  end
end
