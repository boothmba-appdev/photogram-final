class UserAuthenticationController < ApplicationController
  # Uncomment this if you want to force users to sign in before any other actions
  # skip_before_action(:force_user_sign_in, { :only => [:sign_up_form, :create, :sign_in_form, :create_cookie] })

  def sign_in_form
    render({ :template => "user_authentication/sign_in.html.erb" })
  end

  def create_cookie
    user = User.where({ :email => params.fetch("query_email") }).first
    
    the_supplied_password = params.fetch("query_password")
    
    if user != nil
      are_they_legit = user.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/user_sign_in", { :alert => "Incorrect password! 密码错误!" })
      else
        session[:user_id] = user.id
      
        redirect_to("/", { :notice => "Signed in successfully! 登陆成功!" })
      end
    else
      redirect_to("/user_sign_in", { :alert => "No user with that email address! 该邮箱没有注册!" })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully! 退出成功!" })
  end

  def sign_up_form
    render({ :template => "user_authentication/sign_up.html.erb" })
  end

  def create
    @user = User.new
    @user.username = params.fetch("query_username")
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.private = params.fetch("query_private", false)
    
    save_status = @user.save

    if save_status == true
      session[:user_id] = @user.id
      #session[:username] = @user.username
      redirect_to("/", { :notice => "User account created successfully! 用户账户注册成功!"})
    else
      redirect_to("/user_sign_up", { :alert => @user.errors.full_messages.to_sentence })
    end
  end
    
  def edit_profile_form
    render({ :template => "user_authentication/edit_profile.html.erb" })
  end

  def update
    @user = @current_user
    @user_ = @current_user.dup
    @user.username = params.fetch("query_username")
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    #@user.comments_count = params.fetch("query_comments_count")
    #@user.likes_count = params.fetch("query_likes_count")
    @user.private = params.fetch("query_private", false)
    
    if @user.valid?
      @user.save
      redirect_to("/", {:notice => "User account updated successfully! 用户信息成功更新!"})
    else
      @user.username = @user_.username
      @user.email = @user_.email
      @user.password = @user_.password
      @user.private = @user_.private
      render({ :template => "user_authentication/edit_profile_with_errors.html.erb" , :alert => @user.errors.full_messages.to_sentence })
    end
  end

  def update2
    @user2 = @current_user
    @user2.username = params.fetch("query_username")
    @user2.private = params.fetch("query_private", false)
    
    if @user2.valid?
      @user2.save
      redirect_to("/", {:notice => "User account updated successfully! 用户信息成功更新!"})
    else
      render({ :template => "user_authentication/edit_profile_with_errors.html.erb" , :alert => @user.errors.full_messages.to_sentence })
    end
  end

  def destroy
    @current_user.destroy
    reset_session
    
    redirect_to("/", { :notice => "User account cancelled! 用户账户已注销!" })
  end
 
end
