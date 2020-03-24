require 'thor'

module WorkingTimes
  class CLI < Thor
    include State

    option :work_on, aliases: ['-w'], desc: 'Specify what group of work on'
    desc 'start [COMMENT] <option>', 'Start working with comment.'
    def start(comment = '')
      if working?
        puts "You are already on working at #{current_work}."
        puts "To finish this, execute 'wt finish'."
        return
      end

      initialize_data_dir
      initialize_work_log(options[:work_on])

      Record.new(timestamp: DateTime.now, comment: comment, work_on: options[:work_on]).start
      start_work(options[:work_on])
    end

    desc 'st [COMMENT] <option>', 'Short hand for *start*'
    alias st start

    desc 'finish [COMMENT]', 'Finish working on current group.'
    def finish(comment = '')
      unless working?
        puts 'You are not starting work. Execute "wt start" to start working.'
        return
      end

      Record.new(timestamp: DateTime.now, comment: comment).finish
      finish_work
    end

    desc 'fi [COMMENT]', 'Short hand for *finish*'
    alias fi finish

    desc 'rest DURATION', 'Record resting time. e.g. \'wt rest 1h30m\'\'wt rest 1 hour 30 minutes\''
    def rest(duration)
      unless working?
        puts 'You are not starting work. Execute "wt start" to start working.'
        return
      end

      Record.new(timestamp: DateTime.now, duration: duration).rest
    end
  end
end
