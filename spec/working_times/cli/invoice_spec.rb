RSpec.describe 'WorkingTimes::CLI#invoice' do
  include_context 'CLI#init with cleaning'
  let(:dir_invoice_current_term) { File.join(invoice_dir, current_term) }
  let(:path_invoice_current_term) { File.join(dir_invoice_current_term, "#{current_term}.tex") }

  context 'WorkingTimes::Invoice#generate' do
    it 'creates directory like invoice_dir/current_term' do
      expect(Dir.exist?(dir_invoice_current_term)).to be_truty
    end

    it 'copys template as invoice_dir/current_term/current_term.tex by using invoice.template' do
      expect(File.exist?(path_invoice_current_term)).to be_truty
    end
  end
end
