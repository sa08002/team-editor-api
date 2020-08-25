class V1::Articles::SearchesController < V1::BaseApiController
  def index
    articles = Article.search(params[:search])
    render json: articles
  end
end
