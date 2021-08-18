class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end

  def create
    the_follow_request = FollowRequest.new
    the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    if User.where({:id => the_follow_request.recipient_id}).at(0).private
      the_follow_request.status = "pending"
    else
      the_follow_request.status = "accepted"
    end

    if the_follow_request.valid?
      the_follow_request.save
      if the_follow_request.status == "pending"
        redirect_to("/users", { :notice => "Follow request sent! 关注请求已发送!" })
      elsif the_follow_request.status == "accepted"
        redirect_to("/users/#{User.where({:id => the_follow_request.recipient_id}).first.username}", { :notice => "Follow request created successfully! 已成功关注!" })
      else
        redirect_to("/users", { :alert => "Follow request rejected! 关注请求被拒绝!" })
      end
    else
      redirect_to("/users", { :alert => "Already requested! 重复请求!" })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).where({:recipient_id => @current_user.id }).at(0)

    the_follow_request.status = params.fetch("query_status")
    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/users/#{@current_user.username}", { :notice => "Follow request updated successfully! 关注请求更新成功!"} )
    else
      redirect_to("/users/#{@current_user.username}", { :alert => "Follow request failed to update successfully! 关注请求更新失败!" })
    end
  end

  def destroy1
    the_id = params.fetch("path_id")
    if @current_user
      the_follow_request = FollowRequest.where({ :sender_id => @current_user.id }).where({ :id => the_id }).at(0)
      user_name = User.where({:id => the_follow_request.recipient_id}).first.username
      the_follow_request.destroy
      redirect_to("/users/#{user_name}", { :notice => "Follow deleted! 已取关!"} )
      #redirect_to("/users", { :notice => "Follow deleted! 已取关!"} )
    else 
      redirect_to("/user_sign_in", {:alert => "You have to sign in first. 请先登陆!"})
    end
  end

  def destroy2
    the_id = params.fetch("path_id")
    if @current_user
      the_follow_request = FollowRequest.where({ :sender_id => @current_user.id }).where({ :id => the_id }).at(0)
      the_follow_request.destroy
      redirect_to("/users", { :notice => "Follow request deleted! 关注请求已取消!"} )
    else 
      redirect_to("/user_sign_in", {:alert => "You have to sign in first. 请先登陆!"})
    end
  end

end
