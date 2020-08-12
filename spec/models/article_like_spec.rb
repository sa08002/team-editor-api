# == Schema Information
#
# Table name: article_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_article_likes_on_article_id  (article_id)
#  index_article_likes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe ArticleLike, type: :model do

  context "必要な値がある場合" do
    let(:article_like) { build(:article_like) }

    it "記事にいいねができる" do
      expect(article_like).to be_valid
    end
  end
  context "article が空の場合" do
    let(:article_like) { build(:article_like, article: nil) }
    it "いいねできない" do
      article_like.valid?
      expect(article_like.errors.messages[:article]).to include "must exist"
    end
  end

  context "user が空の場合" do
    let(:article_like) { build(:article_like, user: nil) }
    it "いいねできない" do
      article_like.valid?
      expect(article_like.errors.messages[:user]).to include "must exist"
    end
  end

  context "すでにいいねしている場合" do
    let!(:article_liked){create(:article_like)}
    let(:article_like){build(:article_like, user: article_liked.user,article: article_liked.article)}
    it "いいねができない" do
      article_like.valid?
      expect(article_like.errors.messages[:article_id]).to include "has already been taken"
    end
  end
end
