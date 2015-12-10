# Logger class wraps around ruby 'logger' gem to provide diagnostic and workflow information

require 'logger'

# Add in multiple device logging directly into Logger class
class Logger
  # Creates or opens a secondary log file.
  def attach(name)
    @logdev.attach(name)
  end

  # Closes a secondary log file.
  def detach(name)
    @logdev.detach(name)
  end

  class LogDevice # :nodoc:
    attr_reader :devs

    def attach(log)
      @devs ||= {}
      @devs[log] = open_logfile(log)
    end

    def detach(log)
      @devs ||= {}
      @devs[log].close
      @devs.delete(log)
    end

    alias_method :old_write, :write

    def write(message)
      old_write(message)

      @devs ||= {}
      @devs.each do |log, dev|
        dev.write(message)
      end
    end
  end
end # class logger


# Singleton Logger class
module Elementis
  class Log
    # make this class static
    class << self

      #
      # more generic than INFO, useful for debugging issues
      # DEBUG = 0
      # generic, useful information about system operation
      # INFO = 1
      # a warning
      # WARN = 2
      # a handleable error condition
      # ERROR = 3
      # an unhandleable error that results in a program crash
      # FATAL = 4
      # an unknown message that should always be logged
      # UNKNOWN = 5

      def debug(msg)
        log.debug(msg)
      end

      def info(msg)
        log.info(msg)
      end

      def warn(msg)
        log.warn(msg)
      end

      def error(msg)
        log.error(msg)
      end

      def add_device device
        @@devices ||= []
        log.attach(device)
        @@devices << device
      end

      def close
        @@devices.each { |dev| @@logger.detach(dev) }
        @@devices.clear
        log.close if log
      end


      private

      def log
        @@logger ||= initialize_logger
      end

      def initialize_logger
        # log to STDOUT and file
        logger ||= Logger.new(STDOUT)

        # messages that have the set level or higher will be logged
        case Elementis.config.log_level
          when :debug then
            level = Logger::DEBUG
          when :info then
            level = Logger::INFO
          when :warn then
            level = Logger::WARN
          when :error then
            level = Logger::ERROR
          when :fatal then
            level = Logger::FATAL
        end

        logger.level = level

        logger.formatter = proc do |severity, datetime, progname, msg|
          base_msg = "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}][#{severity}]"
          sev = severity.to_s
          if sev.eql?("DEBUG")
            "#{base_msg}   #{msg}\n"
          elsif sev.eql?("INFO")
            "#{base_msg}  > #{msg}\n"
          elsif sev.eql?("WARN")
            "#{base_msg}  X #{msg}\n"
          else
            "#{base_msg} X #{msg}\n"
          end
        end

        logger
      end
    end
  end
end