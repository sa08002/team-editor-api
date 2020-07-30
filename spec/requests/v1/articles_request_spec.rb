require 'rails_helper'

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
      expect(res[0].keys).to eq ["id", "title", "content", "user_id", "created_at", "updated_at"]
      expect(response).to have_http_status(200)
      binding.pry
    end
  end
end
