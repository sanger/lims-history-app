require 'lims-history-app/resource'

module Lims::HistoryApp
  class WarehouseResource
    include Resource

    def initialize(context, model_name, dataset)
      super(context)
      @dataset = dataset
      @model_name = model_name
    end

    def call
      @dataset.all
    end

    def name
      @model_name
    end

    def attributes
      @dataset.columns - private_attributes
    end

    private

    def private_attributes
      [:internal_id]
    end
  end
end
