module Lims::HistoryApp
  module Resource
    def initialize(context)
      @context = context
    end

    def call
      raise NotImplementedError
    end
  end
end
