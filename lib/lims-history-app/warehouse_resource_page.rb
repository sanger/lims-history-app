require 'lims-history-app/resource'

module Lims::HistoryApp
  class WarehouseResourcePage
    include Resource

    def initialize(context, model_name, dataset)
      super(context)
      @dataset = dataset
      @model_name = model_name
      @number_per_page = context.number_of_result_per_page
    end

    def call
      offset = (@context.page - 1) * @number_per_page
      @total = @dataset.count
      @dataset.order(primary_key).limit(@number_per_page).offset(offset).all
    end

    module Pagination
      def url_for(page_type)
        page_number = send(page_type)
        url = "#{@context.request.url}"
        url.gsub!(/\??&?page=\d+/, '')
        url << (url =~ /\?/ ? "&" : "?")
        url << "page=#{page_number}"
      end

      def first_page
        1 
      end

      def last_page
        (@total.to_f / @number_per_page).ceil
      end

      def next_page
        @context.page + 1 unless @context.page == last_page
      end

      def previous_page
       @context.page - 1 unless @context.page == 1
      end
    end
    include Pagination

    def name
      @model_name
    end

    def attributes
      @dataset.columns - private_attributes
    end

    private

    def private_attributes
      [primary_key]
    end

    def primary_key
      :internal_id
    end
  end
end
