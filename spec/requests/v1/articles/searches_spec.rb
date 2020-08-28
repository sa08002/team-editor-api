require "rails_helper"

RSpec.describe "V1::Articles", type: :request do
  before do
    create(:article, title: "楽しいJava")
    create(:article, title: "楽しいRuby")
    create(:article, title: "楽しいJavascript")
    create(:article, title: "楽しいHTML")
    create(:article, title: "楽しいCSS")
    create(:article, title: "楽しいC#")
    create(:article, title: "楽しいC++")
    create(:article, title: "楽しいPython")
    create(:article, title: "楽しいCOBOL")
    create(:article, title: "楽しいSwift")
  end

  describe "GET /v1/articles/searches?q=" do
    subject { get("#{v1_articles_searches_path}?q=#{query}") }

    context "データが存在する状態で Java で検索したとき" do
      let(:query) { "Java" }
      it "Java を含んだデータが表示される" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 2
        expect(res[0]["title"]).to include "Java"
        expect(res[1]["title"]).to include "Java"
        expect(response).to have_http_status(:ok)
      end
    end

    context "データが存在する状態で C で検索したとき" do
      let(:query) { "C" }
      it "C を含んだデータが表示される" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 4
        expect(res[0]["title"]).to include "C"
        expect(res[1]["title"]).to include "C"
        expect(res[2]["title"]).to include "C"
        expect(res[3]["title"]).to include "C"
        expect(response).to have_http_status(:ok)
      end
    end

    context "データが存在する状態で Ruby で検索したとき" do
      let(:query) { "Ruby" }
      it "Ruby を含んだデータが表示される" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 1
        expect(res[0]["title"]).to include "Ruby"
        expect(response).to have_http_status(:ok)
      end
    end

    context "検索項目が空の場合" do
      let(:query) { nil }
      it "全データが表示される" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 10
        expect(response).to have_http_status(:ok)
      end
    end

    context "一致するデータがない PHP で検索したとき" do
      let(:query) { "PHP" }
      it "データが表示されない" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 0
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
