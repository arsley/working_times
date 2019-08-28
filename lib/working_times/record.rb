# frozen_string_literal: true

require 'active_support/time'

module WorkingTimes
  class Record
    attr_reader :timestamp, :comment, :duration, :work_on

    def initialize(timestamp:, comment: nil, duration: nil, work_on: nil)
      @timestamp = timestamp
      @comment   = comment
      @duration  = duration
      @work_on   = work_on
    end

    def start
      if State.working?
        puts "You are already on working at #{State.current_work}."
        puts "To finish this, execute 'wt finish'."
        return
      end

      File.open("#{Config.data_dir}/#{work_on}", 'a+') do |f|
        f.puts "#{timestamp.rfc3339},,#{comment},start"
      end
      State.start_work(work_on)
    end

    def finish
      unless State.working?
        puts 'You are not starting work. Execute "wt start" to start working.'
        return
      end

      File.open("#{Config.data_dir}/#{State.current_work}", 'a+') do |f|
        f.puts ",#{timestamp.rfc3339},#{comment},finish"
      end
      State.finish_work
    end

    def rest
      unless State.working?
        puts 'You are not starting work. Execute "wt start" to start working.'
        return
      end

      parse_rest_finished_at
      File.open("#{Config.data_dir}/#{State.current_work}", 'a+') do |f|
        f.puts "#{timestamp.rfc3339},#{@finished_at},#{comment},rest"
      end

      show_rest_msg
    end

    private

    def parse_rest_finished_at
      @finished_at = timestamp
      if /(?<hour>\d+)\s*h/ =~ duration
        @finished_at += hour.to_i.hour
      end

      if /(?<minute>\d+)\s*m/ =~ duration
        @finished_at += minute.to_i.minute
      end
    end

    def show_rest_msg
      Time::DATE_FORMATS[:rest_finished_at] = '%H:%m:%S'
      puts "You can rest until #{@finished_at.to_s(:rest_finished_at)}."
    end
  end
end
