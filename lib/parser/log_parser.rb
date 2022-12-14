# frozen_string_literal: true

module Parser
  class LogParser
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def parse
      paths.each do |path|
        File.foreach(path) do |line|
          if (match = %r{^(?<page>\/\w*(\/\d?)?)\s(?<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}).*$}.match(line))
            visits.add(*match.captures)
          end
        end
      end

      visits.result(unique: options[:unique])
    end

    private

    def visits
      @visits ||= Parser::VisitAggregate.new
    end

    def paths
      options[:paths]
    end
  end
end
