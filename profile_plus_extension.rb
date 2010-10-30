# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class ProfilePlusExtension < Bionic::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/profile_plus"

  # extension_config do |config|
  #   config.gem 'some-awesome-gem'
  #   config.after_initialize do
  #     run_something
  #   end
  # end

  def activate
    # adds a menu to the admin navigation
    # admin_interface.navigation.add "Profile Plus", "/admin/profile_plus", :after => "Site Management"
    # adds a menu link in a menu
    # admin_interface.navigation.site_management.add "Profile Plus", "/admin/profile_plus", :after => "Site Layouts"
  end

  def deactivate
    # delete the whole menu
    # admin_interface.navigation.delete "Profile Plus"
    # delete just the menu link
    # admin_interface.navigation.site_management.delete "Profile Plus"
  end

end