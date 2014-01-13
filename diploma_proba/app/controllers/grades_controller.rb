class GradesController < ApplicationController
	require 'securerandom'
  before_action :set_grade, only: [:show, :edit, :update, :destroy]
	before_filter :acsess

  # GET /grades
  # GET /grades.json
  def index
    @grades = Grade.all
  end

  # GET /grades/1
  # GET /grades/1.json
  def show
  end

  # GET /grades/new
  def new
    @grade = Grade.new
  end

  # GET /grades/1/edit
  def edit
		@grade = Grade.find(params[:id])
  end

  # POST /grades
  # POST /grades.json
  def create	
		@user_ids = Array.new 
		@gnumber = params[:grade][:number].to_i
		@ggrade = params[:grade][:grade]
    
		if @gnumber < 51	and @gnumber > 0
			@gnumber.times do |number|
				number+=1
				number= "%.2i" %number
				@password= SecureRandom.hex(8)
				@user_params = { "name" => "#{@ggrade}_#{number}_2014", "first_name" => "-", "second_name" => "-", "last_name" => "-", "grade" => "#{@ggrade}", "number" => "#{number}", "password" => "#{@password}" }
				@user = User.new(@user_params)
				@user.save	
		
				@user_ids << @user.id 
			end
		end
		@grade_params = { "grade" => "#{@ggrade}", "number" => "#{@gnumber}", "user_ids" => "#{@user_ids}"}
		@grade = Grade.new(@grade_params)
		respond_to do |format|
      if @grade.save
        format.html { redirect_to @grade, notice: "#{@grade.grade} was successfully created." }
        format.json { render action: 'show', status: :created, location: @grade }
      else
        format.html { render action: 'new' }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end			
			
  end

  # PATCH/PUT /grades/1
  # PATCH/PUT /grades/1.json
  def update
		@send_mails = params[:send_mails]
		@user_ids = @grade.user_ids
		@user_ids = @user_ids.sub "[", ""
		@user_ids = @user_ids.sub "]", ""
		@user_ids = @user_ids.split(",").map {|i| Integer(i) }

		@user_ids.each do |user_id|
			@id_mail = params[:"email#{user_id}"]
		 	@user = User.find_by_id(user_id)
			@user.update_attribute(:email, "#{@id_mail}") 
			if @send_mails == "true" and @user.active == 0 and !@user.email.nil?
				@password= SecureRandom.hex(8)
				@user.update_attribute(:password, "#{@password}")
				UserMailer.welcome_email(@user,@password).deliver	
			end   
		end
	
		@gnumber = params[:grade][:number].to_i
		if @gnumber < 51	and @gnumber > 0
			@gnumber.times do |number|
				number+=1
				number= "%.2i" %number
				@password= SecureRandom.hex(8)
				@user_params = { "name" => "#{@grade.grade}_#{number}_2014", "first_name" => "-", "second_name" => "-", "last_name" => "-", "grade" => "#{@grade.grade}", "number" => "#{number}", "password" => "#{@password}"}
				@user = User.new(@user_params)
				@user.save	
				if @user.id
					@user_ids << @user.id
				end 
			end
			if @gnumber > @grade.number
				@grade.update_attribute(:number, "#{@gnumber}")
			end
			@grade.update_attribute(:user_ids, "#{@user_ids}")
		end
		respond_to do |format|
      if @grade.update_attributes(params[grade_params])
        format.html { redirect_to(grade_url,
          :notice => "#{@grade.grade} was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @grade.errors,
          :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /grades/1
  # DELETE /grades/1.json
  def destroy
		@user_ids= @grade.user_ids
		@user_ids= @user_ids.sub "[", ""
		@user_ids= @user_ids.sub "]", ""
		@user_ids= @user_ids.split(",")
		
		@user_ids.each do |user_id|
			if User.find_by_id(user_id)
				User.find_by_id(user_id).destroy
			end
		end		


    @grade.destroy
    respond_to do |format|
      format.html { redirect_to grades_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grade
      @grade = Grade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grade_params
      params.require(:grade).permit(:number, :grade)
    end

	protected
    def acsess
			user_access= User.find_by_id(session[:user_id]).access 
      unless user_access == "admin" 		
        redirect_to admin_url
      end
    end
end

