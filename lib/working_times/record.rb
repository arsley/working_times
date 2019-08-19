# frozen_string_literal: true

module WorkingTimes
  class Record
    attr_reader :timestamp, :comment, :work_on

    def initialize(timestamp:, comment:, work_on: nil)
      @timestamp = timestamp
      @comment   = comment
      @work_on   = work_on
    end

    def start
      if State.working?
        puts "You are already on working at #{current_work}."
        puts "To finish this, execute 'wt finish'."
        return
      end

      File.open("#{Config.data_dir}/#{work_on}", 'a+') do |f|
        f.puts "start,#{comment},#{timestamp.rfc3339}"
      end
      State.start_work(work_on)
    end

    def finish
      unless State.working?
        puts 'You are not starting work. Execute "wt start" to start working.'
        return
      end

      File.open("#{Config.data_dir}/#{State.current_work}", 'a+') do |f|
        f.puts "finish,#{comment},#{timestamp.rfc3339}"
      end
      State.finish_work
    end
  end
end
