require 'json'

module WorkingTimes
  module Config
    private

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
  end
end
