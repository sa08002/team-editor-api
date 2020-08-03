class V1::CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :user, :article, :created_at, :updated_at
  belongs_to :user
  belongs_to :article
end
