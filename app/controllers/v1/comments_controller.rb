class V1::CommentsController < BaseApiController

  def index
    comments = Comment.all
    render json: comments
  end

  def create
    comment = current_v1_user.comments.create!(comment_params)
    render json: comment
  end

  def destroy
    comment = current_v1_user.comments.find(params[:id])
    comment.destroy!
    render json: comment
  end

  def show
    comment = Comment.find(params[:id])
    render json: comment
  end

  def update
    comment = current_v1_user.comments.find(params[:id])
    comment.update!(comment_params)
    render json: comment
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :article_id)
    end
end
