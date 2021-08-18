class UsersController < ApplicationController
  def index
    @list_of_users = User.all.order({ :username => :asc })
    render({ :template => "users/index.html.erb" })
  end

  def show
    user_name = params.fetch("path_id")
    matching_users = User.where({ :username => user_name })
    @the_user = matching_users.at(0)
    @own_photos = @the_user.own_photos
    if @current_user
      if @current_user.username == @the_user.username
        render({ :template => "users/self.html.erb" })
      elsif @the_user.private
        if @the_user.received_follow_requests.where({:sender_id => @current_user.id}).empty?
          redirect_to("/users", {:alert => "Private account not authorized to view! 隐私账户无权浏览!"})
        elsif @the_user.received_follow_requests.where({:sender_id => @current_user.id}).at(0).status == "accept"
          render({ :template => "users/show.html.erb" })
        else
          redirect_to("/users", {:alert => "Private account not authorized to view! 隐私账户无权浏览!"})
        end
      else
        render({ :template => "users/show.html.erb" })
      end
    else 
      redirect_to("/user_sign_in", {:alert => "Please sign in first! 请先登陆!"})
    end
  end


end