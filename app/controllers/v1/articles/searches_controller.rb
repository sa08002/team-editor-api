class V1::Articles::SearchesController < V1::BaseApiController
  def index
    articles = Article.search(params[:q])
    render json: articles, each_serializer: V1::ArticleSerializer
  end
end
