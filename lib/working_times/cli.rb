# frozen_string_literal: true

require 'thor'

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
  end
end
