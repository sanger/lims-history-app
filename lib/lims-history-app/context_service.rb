require 'lims-history-app/context'

module Lims::HistoryApp
  class ContextService
    def initialize(history_config)
      @configuration = history_config
    end

    def new_context(request)
      Context.new(request).tap do |context|
        context.number_of_result_per_page = @configuration["number_of_result_per_page"]
      end
    end
  end
end
