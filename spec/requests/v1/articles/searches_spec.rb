require "rails_helper"

RSpec.describe "V1::Articles", type: :request do
  describe "GET /v1/articles/searches=Java" do
    subject { get("/v1/articles/searches?search=Java") }

    context "検索結果でデータを取得できた時" do
      let!(:article1) { create(:article, title: "楽しいJava") }
      let!(:article2) { create(:article, title: "楽しいRuby") }
      let!(:article3) { create(:article, title: "楽しいJavascript") }
      it "取得したデータ一覧が表示される" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 2
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /v1/articles/searches?search=" do
    subject { get("/v1/articles/searches?search=") }

    context "検索項目が空の場合" do
      let!(:article1) { create(:article, title: "楽しいJava") }
      let!(:article2) { create(:article, title: "楽しいRuby") }
      let!(:article3) { create(:article, title: "楽しいJavascript") }
      it "全データが表示される" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 3
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /v1/articles/searches?search=PHP" do
    subject { get("/v1/articles/searches?search=PHP") }

    context "検索項目と一致するデータがない場合" do
      let!(:article1) { create(:article, title: "楽しいJava") }
      let!(:article2) { create(:article, title: "楽しいRuby") }
      let!(:article3) { create(:article, title: "楽しいJavascript") }
      it "データが表示されない" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 0
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
