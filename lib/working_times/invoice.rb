module WorkingTimes
  # Class about creating invoice
  # This class is designed to build data_dir/invoices/current_term/invoice.tex
  # from data_dir/invoices/template.tex
  class Invoice
    include Config
    attr_reader :path_template, :salary_per_hour, :tax_rate, :company

    WDAYS = %w[日 月 火 水 木 金 土].freeze
    Date::DATE_FORMATS[:jp_date] = '%m月%d日'
    Time::DATE_FORMATS[:only_hm] = '%H:%M'

    # path_template : String
    # salary_per_hour : Integer
    # tax_rate : Float
    # company : String
    def initialize
      h_invoice_info = invoice_info

      @path_template   = h_invoice_info['template']
      @salary_per_hour = h_invoice_info['salaryPerHour']
      @tax_rate        = h_invoice_info['taxRate']
      @company         = h_invoice_info['company']
    end

    def generate
      create_dir_invoice_current_term
      makeup_worktable
      generate_invoice_from_template
    end

    def build
      puts 'Currently, it is not available to build pdf with latexmk.'
      puts 'Wait for new version!'
    end

    private

    def create_dir_invoice_current_term
      FileUtils.mkdir_p(dir_invoice_current_term)
    end

    def makeup_worktable
      @worktable = [
        '\hline',
        '日付 & 曜日 & 内容 & 出勤 & 退勤 & 休憩 & 労働時間 \\\\ \hline\hline'
      ]
      @allworktime_on_sec = 0.0
      working_times = CSV.open(path_current_term, headers: true)
      row = working_times.first
      date_itr = beginning_of_month(row['started_at'])
      date_itr.upto(date_itr.end_of_month) do |date|
        if row.nil?
          @worktable << format_worktable_row(date)
        elsif same_day?(row['started_at'], date.rfc3339)
          worktime = calculate_worktime(row['started_at'], row['finished_at'], row['rest_sec'])
          @allworktime_on_sec += worktime
          @worktable <<
            format_worktable_row(date, row['comment'], row['started_at'], row['finished_at'], row['rest_sec'], worktime)
          row = working_times.readline
        else
          @worktable << format_worktable_row(date)
        end
      end
    end

    def generate_invoice_from_template
      template = File.readlines(path_template)
      File.open(path_invoice_current_term, 'w') do |f|
        template.each do |t|
          t.gsub!(/##COMPANY##/, company)
          t.gsub!(/##WORKTIME##/, parse_second_to_hh_str(@allworktime_on_sec))
          t.gsub!(/##ACTUALWORKTIME##/, parse_second_to_hm_str(@allworktime_on_sec))
          t.gsub!(/##SALARYPERHOUR##/, salary_per_hour.to_s)
          t.gsub!(/##SALARY##/, salary.to_s)
          t.gsub!(/##TAXRATE##/, "#{(tax_rate * 100).to_i}\\%")
          t.gsub!(/##TAX##/, tax.to_s)
          t.gsub!(/##SALARYWITHTAX##/, (salary + tax).to_s)
          # on gsub, '\' means 'replace sub string'.
          # so we should use block if work as expected
          t.gsub!(/##WORKTABLE##/) { @worktable.join("\n") }

          f.write(t)
        end
      end
    end

    def beginning_of_month(rfc3339)
      Date.parse(rfc3339).beginning_of_month
    end

    def same_day?(one_rfc3339, another_rfc3339)
      Date.parse(one_rfc3339) == Date.parse(another_rfc3339)
    end

    def calculate_worktime(st_rfc3339, fi_rfc3339, rest_sec)
      Time.parse(fi_rfc3339) - Time.parse(st_rfc3339) - rest_sec.to_i
    end

    # date : Date
    # comment : String
    # started_at, finished_at : String (RFC3339)
    # rest, worktime : Integer
    def format_worktable_row(date, comment = nil, started_at = nil, finished_at = nil, rest = nil, worktime = nil)
      "#{date.to_s(:jp_date)} & " \
      "#{WDAYS[date.wday]} & " \
      "#{comment || '-'} & " \
      "#{started_at.nil? ? '-' : Time.parse(started_at).to_s(:only_hm)} & " \
      "#{finished_at.nil? ? '-' : Time.parse(finished_at).to_s(:only_hm)} & " \
      "#{rest.nil? ? '-' : parse_second_to_hm_str(rest.to_i)} & " \
      "#{worktime.nil? ? '-' : parse_second_to_hm_str(worktime)} \\\\ \\hline"
    end

    # second : Float
    def parse_second_to_hm_str(second)
      second = second.to_i
      h = second / 3600
      m = (second - 3600 * h) / 60
      "#{h}:#{m.to_s.rjust(2, '0')}"
    end

    def parse_second_to_hh_str(second)
      (second / 3600).to_i.to_s
    end

    # calculate with 'hour' only
    def salary
      @salary ||= @allworktime_on_sec.to_i / 3600 * salary_per_hour
    end

    def tax
      @tax ||= (salary * tax_rate).to_i
    end
  end
end
