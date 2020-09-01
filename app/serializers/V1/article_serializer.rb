class V1::ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :created_at, :updated_at
  attribute :is_my_article?, key: :is_my_article

  belongs_to :user
  
  def is_my_article?
    current_user = scope.current_v1_user
    object.user_id == current_user.id
  end
end
