require 'thor'
require 'fileutils'

module WorkingTimes
  class CLI < Thor
    include State

    desc 'init WORKON [TERM] [COMPANY]', 'initialize data directory for your working'
    def init(workon, term = 'default', company = '')
      if Dir.exist?(workon)
        puts "WORKON '#{workon}' is already created. Or name conflicted.'"
        return
      end

      FileUtils.mkdir_p(File.join(workon, 'terms'))
      initialize_wtconf(workon, term, company)
    end

    desc 'start [COMMENT] ', 'Start working with comment.'
    def start(comment = '')
      if working?
        puts "You are already on working at #{current_work}."
        puts "To finish this, execute 'wt finish'."
        return
      end

      initialize_term_log

      Record.new(timestamp: DateTime.now, comment: comment, work_on: options[:work_on]).start
      start_work(options[:work_on])
    end

    desc 'st [COMMENT]', 'Short hand for *start*'
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

    private

    def initialize_wtconf(workon, term, company)
      # on initializing, we shouldn't use path helper e.g. Config#data_dir
      data_dir = File.expand_path(workon)
      File.write(File.join(data_dir, 'wtconf.json'), <<~WTCONF)
        {
          "term": "#{term}",
          "company": "#{company}"
        }
      WTCONF
    end

    def initialize_term_log
      return if File.exist?(path_current_term)

      File.write(path_current_term, SCHEMA.join(',') + "\n")
    end
  end
end
