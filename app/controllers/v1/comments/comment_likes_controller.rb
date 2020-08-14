class V1::Comments::CommentLikesController < V1::BaseApiController
  def create
    current_user.comment_likes.create!(comment_id: params[:comment_id])
    render json: { status: "ok" }
  end

  def destroy
    comment_like = current_user.comment_likes.find_by!(comment_id: params[:comment_id])
    comment_like.destroy!
    render json: { status: "ok" }
  end
end
