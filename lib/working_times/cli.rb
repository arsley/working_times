# frozen_string_literal: true

require 'thor'
require 'active_support/time'

module WorkingTimes
  class CLI < Thor
    option :work_on, aliases: ['-w'], desc: 'Specify what group of work on'
    desc 'start [COMMENT] <option>', 'Start working with comment.'
    def start(comment = nil)
      State.initialize_data_dir
      work_on = options[:work_on].nil? ? Config.default_work : options[:work_on]
      Record.new(timestamp: Time.now, comment: comment, work_on: work_on).start
    end

    desc 'st [COMMENT]', 'Short hand for *start*'
    alias st start

    desc 'finish [COMMENT]', 'Finish working on current group.'
    def finish(comment = nil)
      Record.new(timestamp: Time.now, comment: comment).finish
    end

    desc 'fi [COMMENT]', 'Short hand for *finish*'
    alias fi finish
  end
end
