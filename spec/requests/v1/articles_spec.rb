require "rails_helper"

RSpec.describe "V1::Articles", type: :request do
  describe "GET /v1/articles" do
    subject { get(v1_articles_path) }

    before do
      create_list(:article, 3)
    end

    it "記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "content", "created_at", "updated_at", "user"]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /v1/articles/:id" do
    subject { get(v1_article_path(article_id)) }

    context "指定した id の記事が存在する場合" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }
      it "記事の値が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["title"]).to eq article.title
        expect(res["content"]).to eq article.content
      end
    end

    context "指定した id の記事が存在しない場合" do
      let(:article_id) { 100000 }
      it "記事の値が取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /v1/articles" do
    subject { post(v1_articles_path, params: params, headers: headers) }

    context "正常に記事が投稿された場合" do
      let!(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }
      let(:params) { { article: attributes_for(:article).slice(:title, :content) } }
      it "記事のレコードが作成される" do
        expect { subject }.to change { current_user.articles.count }.by(1)
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["content"]).to eq params[:article][:content]
      end
    end
  end

  describe "PATCH /v1/articles/:id" do
    subject { patch(v1_article_path(article.id), params: params, headers: headers) }

    context "正常に記事が変更された場合" do
      let!(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }
      let(:params) { { article: { title: Faker::Lorem.sentence, created_at: Time.current } } }
      let(:article) { create(:article) }
      it "任意のレコードを更新できる" do
        expect { subject }.to change { Article.find(article.id).title }.from(article.title).to(params[:article][:title])
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /v1/articles/:id" do
    subject { delete(v1_article_path(article.id), headers: headers) }

    context "正常に記事が削除された場合" do
      let!(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }
      let!(:article) { create(:article) }
      it "任意のレコードを削除できる" do
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
