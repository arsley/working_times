module WorkingTimes
  module State
    private

    include Config

    def working?
      File.exist?(path_working_flag)
    end

    # return what kind of working on
    def current_work
      File.readlines(path_working_flag).last.chomp
    end

    def start_work
      File.write(path_working_flag, current_term)
      puts START_MSG.sample
    end

    def finish_work
      puts "You were working about #{worked_time}."
      File.delete(path_working_flag)
      puts FINISH_MSG.sample
    end

    def worked_time
      last_record = CSV.read(path_current_term).last
      started_at  = Time.parse(last_record[0])
      finished_at = Time.parse(last_record[1])
      duration    = (finished_at - started_at).to_i
      hour = duration / 3600
      min  = (duration - 3600 * hour) / 60
      "#{hour.to_s.rjust(2, '0')} hour #{min.to_s.rjust(2, '0')} min"
    end
  end
end
