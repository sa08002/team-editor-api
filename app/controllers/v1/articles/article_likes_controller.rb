class V1::Articles::ArticleLikesController < V1::BaseApiController
  def create
    current_user.article_likes.create!(article_id: params[:article_id])
    render json: { status: "ok" }
  end

  def destroy
    article = Article.find(params[:article_id])
    article_like = current_user.article_likes.find_by!(article: article)
    article_like.destroy!
    render json: { status: "ok" }
  end
end
