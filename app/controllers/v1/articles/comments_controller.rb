class V1::Articles::CommentsController < V1::BaseApiController
  def index
    article = Article.find(params[:article_id])
    comments = article.comments
    render json: comments
  end

  def create
    article = Article.find(params[:article_id])
    comment = current_user.comments.new(comment_params)
    comment.article = article
    comment.save!
    render json: comment
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy!
    render json: comment
  end

  def show
    comment = Comment.find(params[:id])
    render json: comment
  end

  def update
    comment = current_user.comments.find(params[:id])
    comment.update!(comment_params)
    render json: comment
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end
end
