unless ENV["LIMS_WAREHOUSEBUILDER_ENV"]
  ENV["LIMS_WAREHOUSEBUILDER_ENV"] = "development" 
end

require 'yaml'
require 'lims-history-app'

Lims::HistoryApp::Server.configure(:development) do |config|
  history_config = YAML.load_file(File.join('config','history.yml'))["development"] 
  config.set :context_service, Lims::HistoryApp::ContextService.new(history_config)
  config.set :base_url, "http://localhost:9292"
end

run Lims::HistoryApp::Server
