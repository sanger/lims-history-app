# TODO: require yaml in lims-warehousebuilder/sequel and remove it here
require 'yaml'
require 'lims-warehousebuilder/model'
require 'lims-history-app/warehouse_resource_page'
require 'lims-history-app/root_resource'

module Lims::HistoryApp
  class Context
    attr_reader :request
    attr_accessor :number_of_result_per_page

    # @param [Sinatra::Request] request
    def initialize(request)
      @request = request
    end

    # @return [Hash]
    def for_root
      RootResource.new(self)
    end

    # @param [String] model_name
    # @param [Hash] parameters
    # @return [WarehouseResource]
    def for_model(model_name, parameters={})
      WarehouseResourcePage.new(self, model_name, dataset_for(model_name, parameters))
    end

    # @param [String] model_name
    # @param [String] uuid
    # @param [Hash] parameters
    # @return [WarehouseResource]
    def for_uuid(model_name, uuid, parameters={})
      dataset = dataset_for(model_name, parameters).where(:uuid => uuid)
      WarehouseResourcePage.new(self, model_name, dataset)
    end

    private

    # @param [String] model_name
    # @return [String]
    def singularize(model_name)
      if model_name[-1..-1] == "s"
        model_name[0..-2]
      else
        model_name
      end
    end

    # @param [String] model_name
    # @param [Hash] parameters
    # @return [Sequel::Dataset]
    def dataset_for(model_name, parameters)
      model = Lims::WarehouseBuilder::Model.model_for(singularize(model_name))
      add_query_parameters(model, parameters)
    end

    # @param [Sequel::Dataset] dataset
    # @param [Hash] parameters
    # @return [Hash]
    def filtered_parameters(dataset, parameters)
      parameters.select { |k,_| dataset.columns.include?(k.to_sym) }
    end

    # @param [Sequel::Dataset] dataset
    # @param [Hash] parameters
    # @return [Sequel::Dataset]
    def add_query_parameters(dataset, parameters)
      filtered_parameters(dataset, parameters).inject(dataset) do |m,(k,v)| 
        m.where(k.to_sym => v)
      end
    end
  end
end
