require "rails_helper"

RSpec.describe "V1::Comments" , type: :request do
  describe "POST /v1/comments" do
    subject{post(v1_comments_path, params: params, headers: headers)}
    context "ユーザーがログインしていて" do

      let!(:current_v1_user){create(:user)}
      let(:headers) { current_v1_user.create_new_auth_token }

      context "コメント対象の記事が存在する時" do

      let!(:article){create(:article)}
      let(:params){{comment: attributes_for(:comment, article_id: article.id)}}
        it "コメントができる" do
          expect{ subject }.to change{current_v1_user.comments.count}.by(1)
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "GET /v1/comments" do
    subject{get(v1_comments_path)}
    context "コメントがある時" do
      before do
        create_list(:comment, 3)
      end
      it "コメントの一覧が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 3
        expect(res[0].keys).to eq ["id", "content", "user_id", "article_id", "created_at", "updated_at"]
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET /v1/comments/:id" do
    subject{get( v1_comment_path(comment_id))}
    context "指定したコメントがある場合" do
      let(:comment){create(:comment)}
      let(:comment_id){comment.id}
      it "コメントの詳細が見れる" do

        subject
        res = JSON.parse(response.body)
        expect(res["id"]).to eq comment.id
        expect(res["content"]).to eq comment.content
        expect(res["user_id"]).to eq comment.user.id
        expect(res["article_id"]).to eq comment.article.id
        expect(response).to have_http_status(200)
      end
    end
  end
  describe "DELETE /v1/comments/:id" do
    subject{delete(v1_comment_path(comment.id),params: params,headers: headers)}
    
    context "ログインしているユーザーのコメントがある時" do
      let(:params){attributes_for(:comment, user_id: current_v1_user.id)}
      let!(:comment){create(:comment, user: current_v1_user)}
      let!(:current_v1_user){create(:user)}
      let(:headers) { current_v1_user.create_new_auth_token }
      it "コメントの削除ができる" do
        binding.pry
        expect{subject}.to change{current_v1_user.comments.count}.by(-1)
        expect(response).to have_http_status(:ok)
      end
    end
  end
  describe "PATCH /v1/comments/:id" do
    subject{patch(v1_comment_path(comment.id),params: params,headers: headers)}
    let(:params){{comment: attributes_for(:comment,user_id: current_v1_user.id)}}
    let!(:comment){create(:comment, user: current_v1_user)}
    let!(:current_v1_user){create(:user)}
    let(:headers) { current_v1_user.create_new_auth_token }
    
    it "記事の更新ができる" do
      
      expect{subject}.to change{comment.reload.content}.from(comment.content).to(params[:comment][:content]) 
      expect(response).to have_http_status(200)
    end
  end
end
