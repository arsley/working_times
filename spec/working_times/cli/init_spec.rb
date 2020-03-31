RSpec.describe 'WorkingTimes::CLI#init' do
  let(:workon) { 'test_workon' }
  let(:term) { 'test_term_1st' }
  let(:company) { 'test_company' }

  after do
    FileUtils.cd('../')
    FileUtils.rm_rf(workon)
  end

  context 'when call with workon' do
    before do
      WorkingTimes::CLI.new.init(workon)
      FileUtils.cd(workon)
    end

    it 'creates directory' do
      FileUtils.cd('../')
      expect(Dir.exist?(workon)).to be_truthy
    end

    it 'creates wtconf.json' do
      expect(File.exist?(path_wtconf)).to be_truthy
    end

    it 'creates terms/' do
      expect(Dir.exist?(term_dir)).to be_truthy
    end

    it 'creates invoices/' do
      expect(File.exist?(invoice_dir)).to be_truthy
    end

    it 'includes default term in wtconf.json' do
      expect(wtconf['term']).to eq('default')
    end

    it 'includes company as a blank in wtconf.json' do
      expect(wtconf['company']).to eq('')
    end
  end

  context 'when call with term' do
    before do
      WorkingTimes::CLI.new.init(workon, term)
      FileUtils.cd(workon)
    end

    it 'includes specified term in wtconf.json' do
      expect(wtconf['term']).to eq(term)
    end
  end

  context 'when call with company' do
    before do
      WorkingTimes::CLI.new.init(workon, term, company)
      FileUtils.cd(workon)
    end

    it 'includes specified company in wtconf.json' do
      expect(wtconf['company']).to eq(company)
    end
  end
end
