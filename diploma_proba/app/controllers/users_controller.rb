class UsersController < ApplicationController
	#skip_before_filter :authorize, :only => [:new, :create]
	before_filter :acsess, :except => :show

  # GET /users
  # GET /users.xml
  def index
    @users = User.order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
		params.permit!
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
		params.permit!
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
		params.permit!
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(users_url,
          :notice => "User #{@user.name} was successfully created.") }
        format.xml  { render :xml => @user,
          :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors,
          :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
		params.permit!
		@user = User.find(params[:id])
		@first_name = params[:user][:first_name].to_s
		@second_name = params[:user][:second_name].to_s
		@last_name = params[:user][:last_name].to_s

		if @first_name != "-" and @second_name != "-" and @last_name != "-"
				@user.update_attribute(:active,1)
		end	

		if User.find_by_id(session[:user_id]).access != "admin" and @user_id == session[:user_id]
			if	User.authenticate(@user.name, params[:old_password]) == @user
				@user.update_attribute(:password, "#{params[:user][:password]}")
			else
				params[:user][:password] = ""
			end
		end
			
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(users_url,
          :notice => "User #{@user.name} was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors,
          :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
		params.permit!
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

protected

    def acsess
			if params[:id]
				@user_id = User.find(params[:id]).id
			end
      unless User.find_by_id(session[:user_id]).access == "admin" or @user_id == session[:user_id]
        redirect_to admin_url
      end
    end

end

