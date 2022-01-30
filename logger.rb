#!/usr/bin/env ruby

module MiniLog
  # Logs messages if they are appropriately-leveled based on config
  def self.log(level=:debug, message=nil)
    return if message.nil?
    level_str = level.to_s.ljust(7, ' ')
    message   = ('--' * $log_shift) + '> ' + message
    puts("[#{level_str}] #{message}") unless LOG_DEGREE[level] > LOG_DEGREE[GLOBAL_LOG_LEVEL]
  end

  # Increase or decrease level of logs, e.g.
  #
  #    [default] > log msg 1
  #    [debug  ] --> step 1.1
  #    [default] --> step 1.2
  #    [debug  ] --> step 1.3
  def shift_log; $log_shift += 1; end
  def unshift_log; $log_shift -= 1; end
  def log_shift(&block)
    shift_log
    block()
    unshift_log
  end

  private
  GLOBAL_LOG_LEVEL = ENV["LOG_LEVEL"]&.to_sym || :debug
  LOG_DEGREE       = { debug: 4, info: 3, default: 2, none: 1 }
  $log_shift       = 0
end
