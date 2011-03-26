class Admin::HowDidYouHearsController < ApplicationController

  # GET /admin/how_did_you_hears
  def index
    @how_did_you_hears = HowDidYouHear.find :all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /admin/how_did_you_hears/new
  def new
    @how_did_you_hear = HowDidYouHear.new
    @how_did_you_hear.position = HowDidYouHear.maximum(:position) + 1
    @how_did_you_hear.active = true
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /admin/how_did_you_hears/:id/edit
  def edit
    @how_did_you_hear = HowDidYouHear.find(params[:id])
  end
  alias :show :edit

  # POST /admin/how_did_you_hears
  def create
    @how_did_you_hear = HowDidYouHear.new(params[:how_did_you_hear])

    respond_to do |format|
      if @how_did_you_hear.save
        flash[:notice] = "How Did You Hear: #{@how_did_you_hear.label} was successfully created."
        format.html { redirect_to(admin_how_did_you_hears_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /admin/how_did_you_hears/:id
  def update
    @how_did_you_hear = HowDidYouHear.find(params[:id])

    respond_to do |format|
      @how_did_you_hear.attributes = params[:how_did_you_hear]
      if @how_did_you_hear.save
        flash[:notice] = "How Did You Hear: #{@how_did_you_hear.label} was successfully updated."
        format.html { redirect_to(admin_how_did_you_hears_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
end
