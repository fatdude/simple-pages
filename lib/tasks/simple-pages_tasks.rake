namespace :db do
  namespace :populate do
    desc 'Populate the controller and actions table'
    task controller_actions: :environment do
      controller_actions = Rails.application.routes.routes.map(&:requirements)      
      controller_actions.delete_if { |c| c.empty? || c[:controller] == 'rails/info' || c[:controller] == 'pages' || c[:controller] =~ /admin/ }

      controller_actions.each do |ca|
        ControllerAction.find_or_create_by_controller_and_action(ca[:controller], ca[:action])
      end
    end
  end  
end