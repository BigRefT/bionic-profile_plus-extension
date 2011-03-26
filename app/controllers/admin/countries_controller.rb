class Admin::CountriesController < ApplicationController

  # GET /admin/countries
  def index
    @site_countries = SiteCountry.find :all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /admin/countries/new
  def new
    @site_country = SiteCountry.new
    # exclude existing countries from selection
    available_countries
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /admin/countries/:id/edit
  def edit
    @site_country = SiteCountry.find(params[:id])
  end
  alias :show :edit

  # POST /admin/countries
  def create
    @site_country = SiteCountry.new(params[:site_country])

    respond_to do |format|
      if @site_country.save
        flash[:notice] = "SiteCountry: #{@site_country.name} was successfully created."
        format.html { redirect_to(admin_countries_path) }
      else
        # exclude existing countries from selection
        available_countries
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /admin/countries/:id
  def update
    @site_country = SiteCountry.find(params[:id])

    respond_to do |format|
      if params[:site_provinces]
        @site_country.site_provinces.update(params[:site_provinces].keys, params[:site_provinces].values)
      end
      @site_country.attributes = params[:site_country]
      if @site_country.save
        flash[:notice] = "SiteCountry: #{@site_country.name} was successfully updated."
        format.html { redirect_to(admin_countries_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  # DELETE /admin/countries/:id
  def destroy
    @site_country = SiteCountry.find(params[:id])
    @site_country.destroy

    respond_to do |format|
      flash[:warning] = "SiteCountry: #{@site_country.name} was successfully deleted."
      format.html { redirect_to(admin_countries_path) }
    end
  end
  
  private
  
  def available_countries
    conditions = nil
    site_countries = SiteCountry.all
    if site_countries.length > 0
      conditions = ["id not in (?)", site_countries.inject([]) { |array, site_country| array << site_country.country_id }]
    end
    @countries = Country.find(:all, :conditions => conditions)
  end

end
