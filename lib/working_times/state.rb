module WorkingTimes
  module State
    private

    include Config

    # generate data directory when does not exist
    # it is usually called by 'start' command
    def initialize_data_dir
      return if exist_data_dir?

      puts 'data directory .wt not found, generated.'
      Dir.mkdir(data_dir)
    end

    # creates csv with header
    def initialize_work_log(work_on)
      work_on = work_on.nil? ? default_work : work_on
      return if File.exist?("#{data_dir}/#{work_on}")

      File.write("#{data_dir}/#{work_on}", SCHEMA.join(',') + "\n")
    end

    def exist_data_dir?
      File.exist?(data_dir)
    end

    def working?
      File.exist?("#{data_dir}/.working")
    end

    # return what kind of working on
    def current_work
      File.readlines("#{data_dir}/.working").last.chomp
    end

    # create ~/.wt/.working include what you working on
    # and show 'started' message
    def start_work(work_on)
      work_on = work_on.nil? ? default_work : work_on
      File.open("#{data_dir}/.working", 'w+') { |f| f.puts work_on }
      puts START_MSG.sample
    end

    # delete 'working' flag
    # and show 'finished' message
    def finish_work
      File.delete("#{data_dir}/.working")
      puts FINISH_MSG.sample
    end
  end
end
