class Admin::PagesController < ApplicationController
  before_filter :get_controller_actions, only: [:edit, :new]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.arrange(order: 'position asc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new(parent_id: params[:page_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.includes(:controller_actions).find(params[:id])
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to [:admin, @page], notice: 'Page was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html do
          get_controller_actions
          render action: "new"
        end
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to [:admin, @page], notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html do
          get_controller_actions
          render action: "edit"
        end
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to admin_pages_url }
      format.json { head :no_content }
    end
  end

  def save_order
    Page.update_all(ancestry: nil)
    i = 0
    params[:page].each do |id, parent_id|
      page = Page.find(id)
      parent_id = parent_id == 'root' ? nil : parent_id
      page.update_attributes(parent_id: parent_id, position: i)
      i += 1
    end
    
    render nothing: true
  end

  protected

    def get_controller_actions
      @controller_actions = ControllerAction.available.order('controller, action asc')
    end
end
