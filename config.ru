require 'lims-history-app'

Lims::HistoryApp::Server.configure(:development) do |config|
  config.set :base_url, "http://localhost:9292"
end

run Lims::HistoryApp::Server
