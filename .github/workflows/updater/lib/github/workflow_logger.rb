# frozen_string_literal: true

require 'logger'

module GitHub
  # Logger for GitHub Workflow
  class WorkflowLogger < Logger
    def initialize(stdout)
      super(stdout)

      self.formatter = proc { |severity, _, _, msg|
        case severity
        when 'DEBUG' then "::debug::#{msg}\n"
        when 'INFO' then "::notice::#{msg}\n"
        when 'WARN' then "::warning::#{msg}\n"
        when 'ERROR', 'FATAL' then "::error::#{msg}\n"
        else "#{msg}\n"
        end
      }
    end
  end
end
