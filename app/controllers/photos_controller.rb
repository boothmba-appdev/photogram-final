class PhotosController < ApplicationController
  def index
    matching_photos = Photo.all
    matching_photos = matching_photos.order({ :created_at => :desc })
    @list_of_photos = Array.new
    matching_photos.each do |a_photo|
      if a_photo.owner.private==FALSE
        @list_of_photos.append(a_photo)
      end
    end
    #@list_of_photos = matching_photos.order({ :created_at => :desc })
    render({ :template => "photos/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    matching_photos = Photo.where({ :id => the_id })
    @the_photo = matching_photos.at(0)
    if @current_user
      if @the_photo.owner.private
        redirect_to("/photos", {:alert => "Not authorized to view! 无权限访问!"})
      else
        render({ :template => "photos/show.html.erb" })
      end
    else 
      redirect_to("/user_sign_in", {:alert => "You have to sign in first. 请先登陆!"})
    end
  end

  def create
    the_photo = Photo.new
    the_photo.owner_id = @current_user.id
    the_photo.image = params.fetch("query_image")
    the_photo.caption = params.fetch("query_caption")
    #the_photo.comments_count = params.fetch("query_comments_count")
    #the_photo.likes_count = params.fetch("query_likes_count")
    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo created successfully. 照片上传成功!" })
    else
      redirect_to("/photos", { :notice => "Photo failed to create successfully. 照片上传失败!" })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)
    the_photo.caption = params.fetch("query_caption")
    if the_photo.owner_id == @current_user.id
      if the_photo.valid?
        the_photo.save
        redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully! 照片更新成功!"} )
      else
        redirect_to("/photos/#{the_photo.id}", { :alert => "Photo failed to update successfully! 照片更新失败!" })
      end
    else
      redirect_to("/photos", { :alert => "Not authorized to modify! 无权限修改!"} )
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)
    if the_photo.owner_id == @current_user.id
      the_photo.destroy
      redirect_to("/photos", { :notice => "Photo deleted successfully! 照片成功删除!"} )
    else
      redirect_to("/photos", { :alert => "Not authorized to delete! 无权限删除!"} )
    end
  end
end
