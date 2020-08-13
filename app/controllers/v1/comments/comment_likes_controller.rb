class V1::Comments::CommentLikesController < V1::BaseApiController

  def create 
    comment = Comment.find(params[:comment_id])
    comment_likes = current_user.comment_likes.create!(comment_id: params[:comment_id])
    render json: { status: "ok" }
  end

  def destroy
    comment = Comment.find(params[:comment_id])
    comment_like = current_user.comment_likes.find_by!(comment: comment)
    comment_like.destroy!
    render json: { status: "ok" }
  end
end
