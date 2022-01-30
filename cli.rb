#!/usr/bin/env ruby
require 'thor'
require 'net/ssh'

class Logger
  # Logs messages if they are appropriately-leveled based on config
  def log(level=:debug, message=nil)
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
  def unshift_log $log_shift -= 1; end

  private
  GLOBAL_LOG_LEVEL = ENV["LOG_LEVEL"]&.to_sym || :debug
  LOG_DEGREE       = { debug: 4, info: 3, default: 2, none: 1 }
  $log_shift       = 0
end

class CLI < Thor
  desc "install (remote_ip)", "installs dokku on host specified by REMOTE_IP"
  def install(host_ip='127.0.0.1')
    log :default, "installing dokku on host #{host_ip}"

    init_host host_ip
  end

  private



  DOKKU_TAG = ENV["DOKKU_TAG"] || 'v0.26.6'
  def init_host host_ip
    shift_log
    Net::SSH.start(host_ip, 'root') do |ssh|
      has_bootstrap = file_exists? ssh, '/tmp/bootstrap2.sh'

      log :debug, "/tmp/bootstrap.sh#{has_bootstrap ? " " : " not "}found"
      unless has_bootstrap
        log :default, "downloading dokku bootstrap.sh @ #{DOKKU_TAG}..."
        ssh.exec!("wget 'https://raw.githubusercontent.com/dokku/dokku/#{DOKKU_TAG}/bootstrap.sh'")
        log :debug, "installing dokku..."
	    ssh.exec!("bash bootstrap.sh")
        log :default, "  done"
      end
    end
    unshift_log
  end

  def file_exists? ssh, path
    has_file = false
    ssh.exec!("ls -l '#{path}'") do |channel, stream, data|
      has_file = true if stream == :stdout && /bootstrap/.match(data)
    end
    return has_file
  end

end

CLI.start(ARGV)
