# frozen_string_literal: true

module WorkingTimes
  module Config
    module_function

    def data_dir
      wtconf['DATADIR']
    end

    def default_work
      wtconf['DEFAULTWORK']
    end

    def wtconf
      conf = default_conf
      begin
        File
          .readlines(File.expand_path('~/.wtconf'))
          .map(&:chomp)
          .each do |row|
            k, v = row.split('=')
            conf[k] = v
          end
      rescue Errno::ENOENT
        puts '~/.wtconf not found, generated.'
        generate_wtconf
      end
      conf
    end

    def default_conf
      { 'DATADIR' => File.expand_path('~/.wt'), 'DEFAULTWORK' => 'default' }
    end

    def generate_wtconf
      File.open(File.expand_path('~/.wtconf'), 'w') { |f| f.puts(default_conf.map { |k, v| "#{k}=#{v}" }) }
    end
  end
end
