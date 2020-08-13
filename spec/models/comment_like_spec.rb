# == Schema Information
#
# Table name: comment_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comment_likes_on_comment_id  (comment_id)
#  index_comment_likes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => comments.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe CommentLike, type: :model do
  context "必要な値がある場合" do
    let(:comment_like) { build(:comment_like) }

    it "コメントにいいねができる" do
      expect(comment_like).to be_valid
    end
  end

  context "comment が空の場合" do
    let(:comment_like) { build(:comment_like, comment: nil) }
    it "いいねできない" do
      comment_like.valid?
      expect(comment_like.errors.messages[:comment]).to include "must exist"
    end
  end

  context "user が空の場合" do
    let(:comment_like) { build(:comment_like, user: nil) }
    it "いいねできない" do
      comment_like.valid?
      expect(comment_like.errors.messages[:user]).to include "must exist"
    end
  end

  context "すでにいいねしている場合" do
    let!(:comment_liked) { create(:comment_like) }
    let(:comment_like) { build(:comment_like, user: comment_liked.user, comment: comment_liked.comment) }
    it "いいねができない" do
      comment_like.valid?
      expect(comment_like.errors.messages[:comment_id]).to include "has already been taken"
    end
  end
end
