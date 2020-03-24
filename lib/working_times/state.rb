module WorkingTimes
  module State
    private

    include Config

    # creates csv with header
    def initialize_work_log(work_on)
      work_on = work_on.nil? ? default_work : work_on
      return if File.exist?("#{data_dir}/#{work_on}")

      File.write("#{data_dir}/#{work_on}", SCHEMA.join(',') + "\n")
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
      puts "You were working about #{worked_time}."
      File.delete("#{data_dir}/.working")
      puts FINISH_MSG.sample
    end

    def worked_time
      last_record = CSV.read("#{data_dir}/#{current_work}").last
      started_at  = Time.parse(last_record[0])
      finished_at = Time.parse(last_record[1])
      duration    = (finished_at - started_at).to_i
      hour = duration / 3600
      min  = (duration - 3600 * hour) / 60
      "#{hour.to_s.rjust(2, '0')} hour #{min.to_s.rjust(2, '0')} min"
    end
  end
end
