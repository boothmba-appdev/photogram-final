class LikesController < ApplicationController
  def index
    matching_likes = Like.all
    @list_of_likes = matching_likes.order({ :created_at => :desc })
    render({ :template => "likes/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    matching_likes = Like.where({ :id => the_id })
    @the_like = matching_likes.at(0)
    render({ :template => "likes/show.html.erb" })
  end

  def create
    the_like = Like.new
    the_like.fan_id = params.fetch("query_fan_id")
    the_like.photo_id = params.fetch("query_photo_id")

    if the_like.valid?
      the_like.save
      redirect_to("/photos/#{the_like.photo_id}", { :notice => "Like created successfully! 点赞成功!" })
    else
      redirect_to("/photos/#{the_like.photo_id}", { :alert => "Like failed to create successfully! 点赞失败!" })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_like = Like.where({ :id => the_id }).at(0)

    the_like.fan_id = params.fetch("query_fan_id")
    the_like.photo_id = params.fetch("query_photo_id")

    if the_like.valid?
      the_like.save
      redirect_to("/likes/#{the_like.id}", { :notice => "Like updated successfully."} )
    else
      redirect_to("/likes/#{the_like.id}", { :alert => "Like failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    if @current_user
      the_like = Like.where({ :fan_id => @current_user.id }).where({ :id => the_id }).at(0)
      the_like.destroy
      redirect_to("/photos/#{the_like.photo_id}", { :notice => "Like deleted successfully! 点赞取消成功!"} )
    else 
      redirect_to("/user_sign_in", {:alert => "You have to sign in first. 请先登陆!"})
    end
  end
end
