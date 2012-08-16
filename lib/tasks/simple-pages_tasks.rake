namespace :db do
  namespace :populate do
    desc 'Populate the controller and actions table'
    task controller_actions: :environment do
      controller_actions = Rails.application.routes.routes.map(&:requirements)
      controller_actions.delete_if { |c| c.empty? || c[:controller] == 'rails/info' || c[:controller] == 'pages' || c[:controller] =~ /admin/ }

      controller_actions.each do |ca|
        puts ca
        begin
          ControllerAction.where(controller: ca[:controller], action: ca[:action]).first_or_create
        rescue Exception => e
          puts e
          puts ca
        end
      end
    end
  end
end