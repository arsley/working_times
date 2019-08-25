# frozen_string_literal: true

module WorkingTimes
  module State
    module_function

    # generate data directory when does not exist
    # it is usually called by 'start' command
    def initialize_data_dir
      return if exist_data_dir?

      puts 'data directory .wt not found, generated.'
      Dir.mkdir(Config.data_dir)
    end

    def exist_data_dir?
      File.exist?(Config.data_dir)
    end

    def working?
      File.exist?("#{Config.data_dir}/.working")
    end

    def current_work
      File.readlines("#{Config.data_dir}/.working").last.chomp
    end

    # create ~/.wt/.working include what you working on
    # and show 'started' message
    def start_work(work_on)
      File.open("#{Config.data_dir}/.working", 'w+') { |f| f.puts work_on }
      puts START_MSG.sample
    end

    # delete 'working' flag
    # and show 'finished' message
    def finish_work
      File.delete("#{Config.data_dir}/.working")
      puts FINISH_MSG.sample
    end
  end
end
