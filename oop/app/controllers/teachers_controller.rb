class TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]
	before_filter :access, :except => [:index, :show]

	require 'csv'

  # GET /teachers
  # GET /teachers.json
  def index
    @teachers = Teacher.all
  end

  # GET /teachers/1
  # GET /teachers/1.json
  def show
  end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
  end

  # GET /teachers/1/edit
  def edit
  end

  # POST /teachers
  # POST /teachers.json
  def create
    file_data = params[:teacher][:file]
		if !file_data.nil?
			CSV.foreach(file_data.path) do |row|
				@name = row[0]
				@email = row[1]
				@business = row[2]
				@teacher_params = { "user_name" => "#{@email}", "name" => "#{@name}", "email" => "#{@email}", "business" => "#{@business}" , "password" => "1234"}   
		  	@teacher = Teacher.new(@teacher_params)	
				@teacher.save
				@predecessor_id = @teacher.predecessor.id
				@teacher_id = @teacher.id
				Teacher.update_all("id = '#{@predecessor_id}'", "id = '#{@teacher_id}'")
				User.update_all("heir_id = '#{@predecessor_id}'", "heir_id = '#{@teacher_id}'")
				#UserMailer.welcome_email(@teacher,"1234").deliver
			end	
		else
			@teacher = Teacher.new(teacher_params)
			UserMailer.welcome_email(@teacher,"1234").deliver
		end

    respond_to do |format|
      if @teacher.save
        #format.html { redirect_to @teacher, notice: 'Teacher was successfully created.' }
        #format.json { render action: 'show', status: :created, location: @teacher }
				format.html { redirect_to teachers_url, notice: 'Teacher was successfully created.' }
      else
        format.html { render action: 'new' }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachers/1
  # PATCH/PUT /teachers/1.json
  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to @teacher, notice: 'Teacher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachers/1
  # DELETE /teachers/1.json
  def destroy
    @teacher.destroy
    respond_to do |format|
      format.html { redirect_to teachers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

		def access
			@usr = User.find_by_id(session[:user_id])
			unless @usr.admin? or @teacher.id == session[:user_id]
        redirect_to teachers_url
      end
		end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
			@usr = User.find_by_id(session[:user_id])
			if @usr.admin?
      	params.require(:teacher).permit(:user_name, :name, :password, :diploma_supervisor, :reviewer, :commissioner, :business, :access)
			else 
				params.require(:teacher).permit(:user_name, :name, :password, :diploma_supervisor, :reviewer, :commissioner, :business)
			end
      
    end
end
