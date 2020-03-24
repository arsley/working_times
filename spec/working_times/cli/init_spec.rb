RSpec.describe 'WorkingTimes::CLI#init' do
  let(:current_dir) { File.expand_path('.') }
  let(:workon) { 'test_workon' }
  let(:term) { 'test_term_1st' }
  let(:company) { 'test_company' }
  let(:data_dir) { File.join(current_dir, workon) }
  let(:json) { JSON.parse(File.read(File.join(data_dir, 'wtconf.json'))) }

  after { FileUtils.rm_rf(data_dir) }

  context 'when call with workon' do
    before { WorkingTimes::CLI.new.init(workon) }

    it 'creates directory' do
      expect(Dir.exist?(data_dir)).to be_truthy
    end

    it 'creates wtconf.json' do
      expect(File.exist?(File.join(data_dir, 'wtconf.json'))).to be_truthy
    end

    it 'creates terms/' do
      expect(Dir.exist?(File.join(data_dir, 'terms'))).to be_truthy
    end

    it 'includes specified workon in wtconf.json' do
      expect(json['workon']).to eq(workon)
    end

    it 'includes default term in wtconf.json' do
      expect(json['term']).to eq('default')
    end

    it 'includes default company in wtconf.json' do
      expect(json['company']).to eq('default')
    end
  end

  context 'when call with term' do
    before { WorkingTimes::CLI.new.init(workon, term) }

    it 'includes specified term in wtconf.json' do
      expect(json['term']).to eq(term)
    end
  end

  context 'when call with company' do
    before { WorkingTimes::CLI.new.init(workon, term, company) }

    it 'includes specified company in wtconf.json' do
      expect(json['company']).to eq(company)
    end
  end
end
