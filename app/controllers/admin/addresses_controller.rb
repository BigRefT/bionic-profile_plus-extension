class Admin::AddressesController < ApplicationController
  before_filter :load_countries_and_provinces, :except => [:destroy]

  # GET /admin/profiles/:profile_id/addresses/new
  def new
    @address = Address.new
    @address.profile_id = params[:profile_id]
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /admin/profiles/:profile_id/addresses/:id/edit
  def edit
    @address = Address.find(params[:id])
  end

  # POST /admin/profiles/:profile_id/addresses
  def create
    @address = Address.new(params[:address])
    @address.profile_id = params[:profile_id]

    respond_to do |format|
      if @address.save
        flash[:notice] = 'Address was successfully created.'
        format.html { redirect_to(edit_admin_profile_path(@address.profile)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /admin/profiles/:profile_id/addresses/:id
  def update
    @address = Address.find(params[:id])

    respond_to do |format|
      if @address.update_attributes(params[:address])
        flash[:notice] = 'Address was successfully updated.'
        format.html { redirect_to(edit_admin_profile_path(@address.profile)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /admin/profiles/:profile_id/addresses/:id
  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    respond_to do |format|
      flash[:warning] = "Address was successfully deleted."
      format.html { redirect_to(edit_admin_profile_path(@address.profile)) }
    end
  end
  
  private

  def load_countries_and_provinces
    @site_countries = SiteCountry.all
    @site_provinces = SiteProvince.active.find(:all, :conditions => ['site_country_id in (?)', @site_countries.map(&:id)])
  end

end
