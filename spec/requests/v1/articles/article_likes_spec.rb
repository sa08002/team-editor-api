require "rails_helper"

RSpec.describe "V1::Articles::ArticleLikes", type: :request do
  describe "POST /v1/articles/:article_id/article_likes" do
    subject { post(v1_article_article_likes_path(article_id), params: params, headers: headers) }

    context "ユーザーがログインしていて" do
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }

      context "いいね対象の記事が存在する時" do
        let(:article) { create(:article) }
        let(:article_id){article.id}
        let(:params) { { article_like: attributes_for(:article_like, article: article) } }

        it "いいねができる" do
          expect { subject }.to change { current_user.article_likes.count }.by(1)
          expect(response).to have_http_status(:ok)
        end
      end

      context "いいね対象の記事がない場合" do
        let(:article_id){1000000}
        let(:params) { { article_like: attributes_for(:article_like, article_id: 100000) } }

        it "いいねできない" do
          expect { subject }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end
  end

  describe "DELETE /v1/articles/:article_id/article_likes/:id" do
    subject { delete(v1_article_article_like_path(article, article_like), params: params, headers: headers) }

    context "任意の記事にログインしているユーザーの" do
      let(:article) { create(:article) }
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }

      context "いいねがある時" do
        let!(:article_like) { create(:article_like, user: current_user, article: article) }
        let(:params) { attributes_for(:article_like, article: article) }

        it "いいねの削除ができる" do
          expect { subject }.to change { current_user.article_likes.count }.by(-1)
          expect(response).to have_http_status(:ok)
        end
      end

        context "いいねがない時" do
          let(:params) { attributes_for(:article_like, article: article) }
          let(:article_like) { create(:article_like, user: current_user, article: article) }

          it "いいね数が減らない" do
            expect { subject }.to change { current_user.article_likes.count }.by(0)
        end
      end
    end
  end
end
