# frozen_string_literal: true

module WorkingTimes
  module Config
    # return where data directory is
    def data_dir
      File.expand_path(wtconf['DATADIR'])
    end

    # return default working project/task/etc...
    def default_work
      wtconf['DEFAULTWORK']
    end

    # parse ~/.wtconf
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

    # default configurations of .wtconf
    def default_conf
      { 'DATADIR' => File.expand_path('~/.wt'), 'DEFAULTWORK' => 'default' }
    end

    # generate configuration file to ~/.wtconf when does not exist
    def generate_wtconf
      File.open(File.expand_path('~/.wtconf'), 'w') { |f| f.puts(default_conf.map { |k, v| "#{k}=#{v}" }) }
    end

    # generate data directory when does not exist
    # it is usually called by 'start' command
    def initialize_task
      return if exist_data_dir?

      puts 'data directory .wt not found, generated.'
      Dir.mkdir(Config.data_dir)
    end

    def exist_data_dir?
      File.exist?(Config.data_dir)
    end
  end
end