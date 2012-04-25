require 'simple-pages/instance_methods'

class << ActionController::Base
  def simple_pages
    include SimplePages::InstanceMethods

    before_filter :get_page, if: lambda { request.format.html? }, unless: lambda { request.params[:controller] =~ /admin\// }
  end
end