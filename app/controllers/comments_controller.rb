class CommentsController < ApplicationController
  def index
    matching_comments = Comment.all
    @list_of_comments = matching_comments.order({ :created_at => :desc })
    render({ :template => "comments/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    matching_comments = Comment.where({ :id => the_id })
    @the_comment = matching_comments.at(0)
    render({ :template => "comments/show.html.erb" })
  end

  def create
    the_comment = Comment.new
    the_comment.author_id = params.fetch("input_user_id")
    the_comment.body = params.fetch("input_comment")
    the_comment.photo_id = params.fetch("input_photo_id")
    if the_comment.valid?
      the_comment.save
      redirect_to("/photos/#{the_comment.photo_id}", { :notice => "Comment updated successfully! 评论添加成功!"} )
    else
      redirect_to("/photos/#{the_comment.photo_id}", { :alert => "Comment failed to update successfully! 评论添加失败!" })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_comment = Comment.where({ :id => the_id }).at(0)
    the_comment.author_id = params.fetch("query_author_id")
    the_comment.body = params.fetch("query_body")
    the_comment.photo_id = params.fetch("query_photo_id")

    if the_comment.author_id == @current_user.id
      if the_comment.valid?
        the_comment.save
        redirect_to("/photos/#{the_comment.photo_id}", { :notice => "Comment updated successfully! 评论更新成功!"} )
      else
        redirect_to("/photos/#{the_comment.photo_id}", { :alert => "Comment failed to update successfully! 评论更新失败!" })
      end
    else
      redirect_to("/photos/#{the_comment.photo_id}", { :alert => "Not authorized to modify! 无权限修改!"} )
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_comment = Comment.where({ :id => the_id }).at(0)
    if the_comment.author_id == @current_user.id
      the_comment.destroy
      redirect_to("/photos/#{the_comment.photo_id}", { :notice => "Comment deleted successfully! 评论删除成功!"} )
    else
      redirect_to("/photos/#{the_comment.photo_id}", { :alert => "Not authorized to delete! 无权限删除!" })
    end
  end
end
