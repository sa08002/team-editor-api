# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Comment, type: :model do
  context "必要な値がある場合" do
    let(:comment) { build(:comment) }
    it "comment が作られる" do
      expect(comment.valid?).to eq true
    end
  end

  context "content が空の場合" do
    let(:comment) { build(:comment, content: nil) }
    it "エラーする" do
      comment.valid?
      expect(comment.errors.messages[:content]).to include "can't be blank"
    end
  end

  context "article が空の場合" do
    let(:comment) { build(:comment, article: nil) }
    it "エラーする" do
      comment.valid?
      expect(comment.errors.messages[:article]).to include "must exist"
    end
  end

  context "ユーザーがいない場合" do
    let(:comment) { build(:comment, user: nil) }
    it "エラーする" do
      comment.valid?
      expect(comment.errors.messages[:user]).to include "must exist"
    end
  end
end
