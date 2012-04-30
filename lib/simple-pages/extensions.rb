require 'simple-pages/instance_methods'
require 'simple-pages/class_methods'

class << ActionController::Base
  def simple_pages
    # Include instance methods
    include SimplePages::InstanceMethods

    # Include dynamic class methods
    extend SimplePages::ClassMethods

    before_filter :get_page, if: lambda { request.format.html? }, unless: lambda { request.params[:controller] =~ /admin\// }
  end
end