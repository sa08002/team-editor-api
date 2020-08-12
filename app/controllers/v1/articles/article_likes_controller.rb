class V1::Articles::ArticleLikesController < V1::BaseApiController
  def create
    article = Article.find(params[:article_id])
    article_like = current_user.article_likes.new
    article_like.article = article
    article_like.save!
    render json: article_like
  end

  def destroy
    article = Article.find(params[:article_id])
    article_like = current_user.article_likes.find_by(article_id: article.id)
    article_like.destroy!
    render json: article_like
  end
end
