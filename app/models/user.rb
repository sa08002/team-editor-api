# frozen_string_literal: true

class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
end
