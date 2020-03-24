# frozen_string_literal: false

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
      updated_csv = ''
      CSV.filter(File.open("#{data_dir}/#{current_work}"), updated_csv, OPTIONS) do |row|
        next if row.header_row?
        next unless row['finished_at'].empty?

        row['finished_at'] = timestamp.rfc3339
        row['comment'] = comment
      end
      File.write("#{data_dir}/#{current_work}", updated_csv)
    end

    def rest
      parse_rest_sec

      updated_csv = ''
      CSV.filter(File.open("#{data_dir}/#{current_work}"), updated_csv, OPTIONS) do |row|
        next if row.header_row?
        next unless row['finished_at'].empty?

        row['rest_sec'] = @rest_sec
      end
      File.write("#{data_dir}/#{current_work}", updated_csv)
    end

    private

    def parse_rest_sec
      @rest_sec = 0
      if /(?<hour>\d+)\s*h/ =~ duration
        @rest_sec += hour.to_i * 3600
      end

      if /(?<minute>\d+)\s*m/ =~ duration
        @rest_sec += minute.to_i * 60
      end
    end
  end
end
