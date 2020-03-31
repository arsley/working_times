require 'json'

module WorkingTimes
  module Config
    private

    def data_dir
      File.expand_path('.')
    end

    def path_wtconf
      File.join(data_dir, 'wtconf.json')
    end

    def term_dir
      File.join(data_dir, 'terms')
    end

    def path_working_flag
      File.join(data_dir, '.working')
    end

    def current_term
      wtconf['term']
    end

    def path_current_term
      File.join(term_dir, current_term)
    end

    def current_company
      wtconf['company']
    end

    def invoice_dir
      File.join(data_dir, 'invoices')
    end

    def invoice_info
      wtconf['invoice']
    end

    def wtconf
      JSON.parse(File.read(path_wtconf))
    end
  end
end
