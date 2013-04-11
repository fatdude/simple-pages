namespace :db do
  namespace :populate do
    desc 'Populate the controller and actions table'
    task controller_actions: :environment do
      controller_actions = Rails.application.routes.routes.map(&:requirements)
      controller_actions.delete_if { |c| c.empty? || c[:controller] == 'rails/info' || c[:controller] == 'pages' || c[:controller] =~ /admin/ }

      controller_actions.each do |ca|
        begin
          controller_action = ControllerAction.where(controller: ca[:controller], action: ca[:action]).first_or_initialize
          if controller_action.persisted?
            puts "#{ca[:controller]} - #{ca[:action]}: ControllerAction already exists"
          else
            puts "Added: #{ca}"
            controller_action.save
          end
        rescue Exception => e
          puts e
          puts ca
        end
      end
    end
  end
end