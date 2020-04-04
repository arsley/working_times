RSpec.describe 'WorkingTimes::CLI#invoice' do
  include_context 'CLI#init with cleaning'
  let(:dir_invoice_current_term) { File.join(invoice_dir, current_term) }
  let(:path_invoice_current_term) { File.join(dir_invoice_current_term, "#{current_term}.tex") }
  let(:sample_worklog) do
    <<~LOG
      started_at,finished_at,rest_sec,comment
      2020-04-02T15:57:58+09:00,2020-04-02T18:58:02+09:00,3600,""
      2020-04-03T15:57:58+09:00,2020-04-03T18:58:02+09:00,0,""
      2020-04-04T15:57:58+09:00,2020-04-04T18:58:02+09:00,0,""
      2020-04-05T15:57:58+09:00,2020-04-05T18:58:02+09:00,0,""
      2020-04-06T15:57:58+09:00,2020-04-06T18:58:02+09:00,0,""
      2020-04-07T15:57:58+09:00,2020-04-07T18:58:02+09:00,0,""
      2020-04-08T15:57:58+09:00,2020-04-08T18:58:02+09:00,0,""
    LOG
  end
  let(:sample_template) do
    <<~TEMPLATE
      \\documentclass[12pt]{jsarticle}
      \\begin{document}
      ##WORKTIME##
      ##COMPANY##
      ##TAXRATE##
      ##SALARYPERHOUR##
      ##SALARY##
      ##SALARYWITHTAX##
      ##TAX##
      \\end{document}
    TEMPLATE
  end
  let(:sample_wtconf) do
    <<~CONF
      {
        "term": "#{term}",
        "invoice": {
          "company": "#{company}",
          "template": "invoices/main.tex",
          "salaryPerHour": 1000,
          "taxRate": 0.1
        }
      }
    CONF
  end

  context 'WorkingTimes::Invoice#generate' do
    before do
      File.write(path_wtconf, sample_wtconf)
      File.write(path_current_term, sample_worklog)
      File.write(invoice_info['template'], sample_template)
      WorkingTimes::CLI.new.invoice
    end

    it 'creates directory like invoice_dir/current_term' do
      expect(Dir.exist?(dir_invoice_current_term)).to be_truthy
    end

    it 'creates file of invoice to invoice_dir/current_term/current_term.tex' do
      expect(File.exist?(path_invoice_current_term)).to be_truthy
    end
  end
end
