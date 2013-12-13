require 'lims-history-app/resource'

module Lims::HistoryApp
  class RootResource
    include Resource
    
    def call
      {}.tap do |root|
        Lims::WarehouseBuilder::ResourceTools::Database::S2_MODELS.each do |model|
          root["#{model}s"] = {:read => "#{@context.request.base_url}/#{model}s"}
        end
      end 
    end
  end
end
