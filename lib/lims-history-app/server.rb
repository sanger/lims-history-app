require 'sinatra'
require 'facets'
require 'rabl'
require 'lims-history-app/context'

Rabl.register!

module Lims
  module HistoryApp
    class Server < Sinatra::Base

      def general_error(status_code, *messages)
        halt(status_code, { 'Content-Type' => 'application/json' }, %Q{{"general":#{messages.inspect}}})
      end

      def filtered_query_parameters
        request.params.mash do |k,v|
          [k, Rack::Utils.escape_html(v)]
        end
      end

      before do
        content_type "application/json" 
        @context = Context.new(request)
        @query_parameters = filtered_query_parameters
      end

      before '/' do
        @resource = @context.for_root
      end

      before '/:model' do
        @resource = @context.for_model(params[:model], @query_parameters)
      end

      before '/:model/:uuid' do
        @resource = @context.for_uuid(params[:model], params[:uuid], @query_parameters)
      end

      get '/:model/?:uuid?' do
        @objects = @resource.call
        rabl :resource, :format => :json
      end

      get '/' do
        rabl :root, :format => :json
      end
    end
  end
end
