#!/usr/bin/env ruby

module MiniLog
  # Logs messages if they are appropriately-leveled based on config
  def log(level=:debug, message=nil)
    return if message.nil?
    level_str = level.to_s.ljust(7, ' ')
    message   = ('--' * @@log_shift) + '> ' + message
    puts("[#{level_str}] #{message}") unless @@log_degree[level] > @@log_degree[@@log_level]
  end

  # Increase or decrease level of logs, e.g.
  #
  #    [default] > log msg 1
  #    [debug  ] --> step 1.1
  #    [default] --> step 1.2
  #    [debug  ] --> step 1.3
  def shift_log;   @@log_shift += 1; end
  def unshift_log; @@log_shift -= 1; end
  def log_shift(&block)
    shift_log
    yield
    unshift_log
  end

  private
  @@log_level  = ENV["LOG_LEVEL"]&.to_sym || :debug
  @@log_degree = { debug: 4, info: 3, default: 2, none: 1, error: 0 }
  @@log_shift  = 0
end
