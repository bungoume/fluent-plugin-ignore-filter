module Fluent
  class IgnoreFilter < Filter
    Fluent::Plugin.register_filter('ignore', self)

    REGEXP_MAX_NUM = 20

    (1..REGEXP_MAX_NUM).each {|i| config_param :"regexp#{i}", :string, :default => nil }
    (1..REGEXP_MAX_NUM).each {|i| config_param :"exclude#{i}", :string, :default => nil }

    # for test
    attr_reader :regexps
    attr_reader :excludes

    def configure(conf)
      super

      @regexps = []
      (1..REGEXP_MAX_NUM).each do |i|
        next unless conf["regexp#{i}"]
        key, regexp = conf["regexp#{i}"].split(/ /, 2)
        raise ConfigError, "regexp#{i} does not contain 2 parameters" unless regexp
        @regexps.push({key: key, regexp: Regexp.compile(regexp)})
      end

      @excludes = []
      (1..REGEXP_MAX_NUM).each do |i|
        next unless conf["exclude#{i}"]
        key, regexp = conf["exclude#{i}"].split(/ /, 2)
        raise ConfigError, "exclude#{i} does not contain 2 parameters" unless regexp
        @excludes.push({key: key, regexp: Regexp.compile(regexp)})
      end
    end

    def filter(tag, time, record)
      result = record
      begin
        catch(:break_loop) do
          @regexps.each do |o|
            throw :break_loop unless match(o[:regexp], record[o[:key]].to_s)
          end
          @excludes.each do |o|
            throw :break_loop if match(o[:regexp], record[o[:key]].to_s)
          end
          result = nil
        end
      rescue => e
        log.warn "failed to grep events", :error_class => e.class, :error => e.message
        log.warn_backtrace
      end
      result
    end

    private

    def match(regexp, string)
      begin
        return regexp.match(string.force_encoding('utf-8'))
      rescue ArgumentError => e
        raise e unless e.message.index("invalid byte sequence in".freeze).zero?
        log.info "invalid byte sequence is replaced in `#{string}`"
        string = string.scrub('?')
        retry
      end
      return true
    end
  end
end
