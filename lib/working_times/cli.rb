# frozen_string_literal: true

require 'thor'
require 'active_support/time'

module WorkingTimes
  class CLI < Thor
    desc 'start [COMMENT]', 'Start working with comment'
    def start(comment: nil)
      puts 'Start!!'
    end

    desc 'finish [COMMENT]', 'Finish working'
    def finish(comment: nil)
      puts 'Yeah!!'
    end

    desc 'current', 'Print current time'
    def current
      puts Time.now.rfc3339
    end
  end
end
