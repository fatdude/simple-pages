namespace :db do
  namespace :populate do
    desc 'Populate the controller and actions table'
    task controller_actions: :environment do
      ControllerAction.delete_all

      controller_actions = Rails.application.routes.routes.map(&:requirements)
      controller_actions.delete_if { |c| c.empty? || c[:controller] == 'rails/info' || c[:controller] == 'pages' || c[:controller] =~ /admin/ }

      controller_actions.each do |ca|
        begin
          ControllerAction.create(ca)
        rescue
        end
      end
    end
  end
end