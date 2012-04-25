module SimplePages
  module InstanceMethods
    protected

      def get_page
        @page = Page.for_request(request).includes(:page_parts).published.first
      end
  end
end