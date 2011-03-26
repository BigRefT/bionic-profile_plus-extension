ActionController::Routing::Routes.draw do |map|
  map.request_password    '/forms/request_password',    :controller => 'home', :action => 'request_password',   :conditions => { :method => :post }
  map.new_password        '/forms/new_password',        :controller => 'home', :action => 'new_password',       :conditions => { :method => :post }
  map.marketing_sign_up   '/forms/marketing_sign_up',   :controller => 'home', :action => 'marketing_sign_up',  :conditions => { :method => :post }
  map.register_account    '/forms/register_account',    :controller => 'home', :action => 'register_account',   :conditions => { :method => :post }
  map.postal_code_lookup  '/forms/postal_code_lookup',  :controller => 'home', :action => 'postal_code_lookup', :conditions => { :method => :post }

  map.create_address '/forms/address/create',     :controller => 'customer', :action => 'create_address', :conditions => { :method => :post }
  map.update_address '/forms/address/update/:id', :controller => 'customer', :action => 'update_address', :conditions => { :method => :post }
  map.delete_address '/forms/address/delete/:id', :controller => 'customer', :action => 'delete_address', :conditions => { :method => :delete }

  map.namespace :admin do |admin|
    admin.resources :addresses, :path_prefix => '/profiles/:profile_id', :name_prefix => 'admin_profile_', :except => [:index, :show]
    admin.resources :countries
    admin.resources :how_did_you_hears
  end
end