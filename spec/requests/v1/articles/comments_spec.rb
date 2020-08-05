require "rails_helper"

RSpec.describe "V1::Articles::Comments", type: :request do
  describe "POST /v1/articles/:article_id/comments" do 
    subject { post(v1_article_comments_path(article), params: params, headers: headers) }

    context "ユーザーがログインしていて" do
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }

      context "コメント対象の記事が存在する時" do
        let(:article) { create(:article) }
        let(:params) { { comment: attributes_for(:comment, article_id: article.id) } }

        it "コメントができる" do
          expect { subject }.to change { current_user.comments.count }.by(1)
          expect(response).to have_http_status(:ok)
          res = JSON.parse(response.body)
          expect(res["content"]).to eq params[:comment][:content]
        end
      end
    end
  end

  describe "GET /v1/articles/:article_id/comments" do
    subject { get(v1_article_comments_path(article)) }

    context "任意の記事に" do
      let(:article) { create(:article) }
      let(:article_id){article.id}

      context "コメントがある時" do
        let!(:comment){create_list(:comment,3 ,article_id: article.id)}
        it "コメントの一覧が取得できる" do
          subject
          res = JSON.parse(response.body)
          expect(res.length).to eq 3
          expect(res[0].keys).to eq ["id", "content", "user_id", "article_id", "created_at", "updated_at"]
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "/v1/articles/:article_id/comments/:id" do
    subject { get(v1_article_comment_path(article, comment_id)) }

    context "任意の記事に" do
      let(:article) { create(:article) }

      context "指定したコメントがある場合" do
        let(:comment) { create(:comment) }
        let(:comment_id) { comment.id }

        it "コメントの詳細が見れる" do
          subject
          res = JSON.parse(response.body)
          expect(res["id"]).to eq comment.id
          expect(res["content"]).to eq comment.content
          expect(res["user_id"]).to eq comment.user.id
          expect(res["article_id"]).to eq comment.article.id
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "DELETE /v1/articles/:article_id/comments/:id" do
    subject { delete(v1_article_comment_path(article, comment_id), params: params, headers: headers) }

    context "任意の記事に" do
      let(:article) { create(:article) }

      context "ログインしているユーザーのコメントがある時" do
        let(:current_user) { create(:user) }
        let(:headers) { current_user.create_new_auth_token }
        let!(:comment) { create(:comment, user: current_user) }
        let(:comment_id) { comment.id }
        let(:params) { attributes_for(:comment, user: current_user.id) }

        it "コメントの削除ができる" do
          expect { subject }.to change { current_user.comments.count }.by(-1)
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "PATCH /v1/articles/:article_id/comments/:id" do
    subject { patch(v1_article_comment_path(article, comment_id), params: params, headers: headers) }

    context "任意の記事に" do
      let(:article) { create(:article) }

      context "ログインしているユーザーのコメントがある時" do
        let(:current_user) { create(:user) }
        let(:headers) { current_user.create_new_auth_token }
        let(:comment) { create(:comment, user: current_user) }
        let(:comment_id) { comment.id }
        let(:params) { { comment: attributes_for(:comment, user: current_user.id) } }

        it "コメントの更新ができる" do
          expect { subject }.to change { comment.reload.content }.from(comment.content).to(params[:comment][:content])
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
