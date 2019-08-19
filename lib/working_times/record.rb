# frozen_string_literal: true

module WorkingTimes
  class Record
    attr_reader :timestamp, :comment, :work_on

    def initialize(timestamp:, comment:, work_on:)
      @timestamp = timestamp
      @comment   = comment
      @work_on   = work_on
    end

    def start
      if working?
        puts "You are already on working at #{current_work}."
        puts "To finish this, execute 'wt finish [COMMENT] -w #{current_work}'."
        return
      end
      start_work(work_on)
      File.open("#{Config.data_dir}/#{work_on}", 'a+') do |f|
        f.puts "start,#{comment},#{timestamp.rfc3339}"
      end
    end

    def self.finish
      # code
    end

    private

    def working?
      File.exist?("#{Config.data_dir}/.working")
    end

    def current_work
      File.readlines("#{Config.data_dir}/.working").last.chomp
    end

    # create ~/.wt/.working include what you working on
    def start_work(work_on)
      File.open("#{Config.data_dir}/.working", 'w+') { |f| f.puts work_on }
    end

    # delete 'working' flag
    def finish_work
      File.delete("#{Config.data_dir}/.working")
    end
  end
end
