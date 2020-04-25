module WorkingTimes
  VERSION = '0.7.1'.freeze

  START_MSG = [
    'Have a nice work!',
    'Have a nice day!'
  ].freeze

  FINISH_MSG = [
    'Great job!',
    'Time to beer!'
  ].freeze

  SCHEMA = [
    'started_at',  # DateTime#rfc3339
    'finished_at', # DateTime#rfc3339
    'rest_sec',    # Integer (inidicates second)
    'comment'      # String
  ].freeze
end
