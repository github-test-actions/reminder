module ExtentLogger
  # override ActiveSupport::Logger methods
  class Logger < ActiveSupport::Logger
    attr_accessor :logger_for_single_line
    attr_accessor :symbol_line_seperator

    # instead of `attr_accessor`, We need `thread_mattr_accessor`
    # beacuse, we need to deal with multi-threaded web servers e.g. puma
    # Note, all threads share a single logger instance, but the logger
    # needs to separate the log messages for each thread and request.

    thread_mattr_accessor :log_msg_cache

    REGEX_STARTED = /Started\s(GET|POST|PUT|DELETE|PATCH|HEAD|OPTION|JOB)\s/.freeze

    # @param [String] dev_log_file_path
    #   multi-line log, The path name of the file
    # @param [String] splunk_log_file_path
    #   single-line log. The path name of the file.
    def initialize(dev_log_file_path, splunk_log_file_path)
      super(dev_log_file_path)
      self.log_msg_cache = []
      @logger_for_single_line = ::Logger.new(splunk_log_file_path)
    end

    def format_message(severity, time, progname, message)
      msg = super
      add_to_log_msg_cache(msg)
      msg
    end

    # internal message cache is uesd to add a message string
    # The message is converted to UTF-8 encoding before it is added to the cache.
    # `symbol_line_seperator` is used replace all new-line characters be the current.
    #
    # @param [String] msg
    #   The message is to be added to the message cache.
    #
    def add_to_log_msg_cache(msg)
      return unless logger_for_single_line
      msg = msg.encode('UTF-8', invalid: :replace, undef: :replace) if msg.encoding != Encoding::UTF_8
      flush_log_msg_cache if msg.match?(REGEX_STARTED)
      self.log_msg_cache = [] if log_msg_cache.nil? || log_msg_cache.count > 1000
      log_msg_cache << msg.strip.gsub("\n", symbol_line_seperator || '§')
    end

    # At the end of each request, this method is called by the Rails::Rack::Logger middleware.
    def flush
      flush_log_msg_cache
    end

    # Joins the cached messages to a single line, writes it to the
    # single line logger and clears the cache.
    def flush_log_msg_cache
      return if log_msg_cache.blank?
      logger_for_single_line << log_msg_cache.join(symbol_line_seperator || '§') + "\n" if logger_for_single_line
    ensure
      self.log_msg_cache = []
    end
  end

  class ExtentLoggerFormatter < ActiveSupport::Logger::SimpleFormatter
    def call(severity, time, progname, msg)
      "#{String === msg ? msg : msg.inspect}\n"
    end
  end
end