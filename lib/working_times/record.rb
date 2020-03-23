# frozen_string_literal: true

require 'active_support/time'
require 'csv'

module WorkingTimes
  class Record
    include State

    OPTIONS = { headers: true, return_headers: true, write_headers: true }.freeze

    attr_reader :timestamp, :comment, :duration, :work_on

    def initialize(timestamp:, comment: nil, duration: nil, work_on: nil)
      @timestamp = timestamp
      @comment   = comment
      @duration  = duration
      @work_on   = work_on.nil? ? default_work : work_on
    end

    def start
      CSV.open("#{data_dir}/#{work_on}", 'a+', OPTIONS) do |csv|
        csv.puts([timestamp.rfc3339, '', 0, comment])
      end
    end

    def finish
      File.open("#{data_dir}/#{current_work}", 'a+') do |f|
        f.puts ",#{timestamp.rfc3339},#{comment},finish"
      end
    end

    def rest
      parse_rest_finished_at
      File.open("#{data_dir}/#{current_work}", 'a+') do |f|
        f.puts "#{timestamp.rfc3339},#{@finished_at.rfc3339},#{comment},rest"
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
      Time::DATE_FORMATS[:rest_finished_at] = '%H:%M:%S'
      puts "You can rest until #{@finished_at.to_s(:rest_finished_at)}."
    end
  end
end
