class DiplomaWorksController < ApplicationController
	skip_before_filter :authorize
  before_action :set_diploma_work, only: [:show, :edit, :update, :destroy]
	
	before_filter :acsess, :except => [:index, :show]

  # GET /diploma_works
  # GET /diploma_works.json
  def index
    @diploma_works = DiplomaWork.all
  end

  # GET /diploma_works/1
  # GET /diploma_works/1.json
  def show
  end

  # GET /diploma_works/new
  def new
    @diploma_work = DiplomaWork.new
  end

  # GET /diploma_works/1/edit
  def edit
			
  end

  # POST /diploma_works
  # POST /diploma_works.json
  def create
    @diploma_work = DiplomaWork.new(diploma_work_params)

    respond_to do |format|
      if @diploma_work.save
        format.html { redirect_to @diploma_work, notice: 'Diploma work was successfully created.' }
        format.json { render action: 'show', status: :created, location: @diploma_work }
      else
        format.html { render action: 'new' }
        format.json { render json: @diploma_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /diploma_works/1
  # PATCH/PUT /diploma_works/1.json
  def update
    respond_to do |format|
      if @diploma_work.update(diploma_work_params)
        format.html { redirect_to @diploma_work, notice: 'Diploma work was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @diploma_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diploma_works/1
  # DELETE /diploma_works/1.json
  def destroy
    @diploma_work.destroy
    respond_to do |format|
      format.html { redirect_to diploma_works_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_diploma_work
      @diploma_work = DiplomaWork.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def diploma_work_params
      params.require(:diploma_work).permit(:title, :description, :student, :graduation_supervisor, :agreed, :approved)
    end

protected
    def acsess
			user_access= User.find_by_id(session[:user_id]).access 
			user_t= User.find_by_id(session[:user_id]).user_type 
	
      unless user_access == "admin" or user_t == "graduation supervisor"  		
        redirect_to diploma_works_url
      end
    end
end
