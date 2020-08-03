# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  content    :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  context "正常に入力されている場合" do
    let(:article) { create(:article) }
    it "記事が作られる" do
      expect(article).to be_valid
    end
  end

  context "title が空の場合" do
    let(:article) { build(:article, title: nil) }
    it "エラーする" do
      article.valid?
      expect(article.errors.messages[:title]).to include "can't be blank"
    end
  end

  context "content が空の場合" do
    let(:article) { build(:article, content: nil) }
    it "エラーする" do
      article.valid?
      expect(article.errors.messages[:content]).to include "can't be blank"
    end
  end
end
