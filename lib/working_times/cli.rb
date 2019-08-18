# frozen_string_literal: true

require 'thor'
require 'active_support/time'

module WorkingTimes
  class CLI < Thor
    desc 'start [COMMENT]', 'Start working with comment'
    def start(comment = nil)
      puts comment if comment
      puts 'Start!!'
    end

    desc 'st [COMMENT]', 'Short hand for *start*'
    alias st start

    desc 'finish [COMMENT]', 'Finish working'
    def finish(comment = nil)
      puts comment if comment
      puts 'Yeah!!'
    end

    desc 'fi [COMMENT]', 'Short hand for *finish*'
    alias fi finish

    desc 'current', 'Print current time'
    def current
      puts Time.now.rfc3339
    end
  end
end
