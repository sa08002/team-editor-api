require "rails_helper"

RSpec.describe "V1::Comments::CommentLikes", type: :request do
  describe "POST /v1/comments/:comment_id/comment_likes" do
    subject { post(v1_comment_comment_likes_path(comment_id), params: params, headers: headers) }

    context "ユーザーがログインしていて" do
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }

      context "いいね対象のコメントが存在する時" do
        let(:comment) { create(:comment) }
        let(:comment_id) { comment.id }
        let(:params) { { comment_like: attributes_for(:comment_like, comment: comment) } }

        it "いいねができる" do
          expect { subject }.to change { current_user.comment_likes.count }.by(1)
          expect(response).to have_http_status(:ok)
        end
      end

      context "いいね対象のコメントがない場合" do
        let(:comment_id) { 1_000_000 }
        let(:params) { { comment_like: attributes_for(:comment_like, comment_id: 100000) } }

        it "いいねできない" do
          expect { subject }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end
  end

  describe "DELETE /v1/comments/:comment_id/comment_likes/:id" do
    subject { delete(v1_comment_comment_like_path(comment, comment_like), headers: headers) }

    context "任意のコメントにログインしているユーザーの" do
      let(:comment) { create(:comment) }
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }

      context "いいねがある時" do
        let!(:comment_like) { create(:comment_like, user: current_user, comment: comment) }

        it "いいねの削除ができる" do
          expect { subject }.to change { current_user.comment_likes.count }.by(-1)
          expect(response).to have_http_status(:ok)
        end
      end

      context "いいねがない時" do
        let(:other_comment) { create(:comment) }
        let!(:comment_like) { create(:comment_like, user: current_user, comment: other_comment) }

        it "見つけられず、削除できない" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                                change { current_user.comment_likes.count }.by(0)
        end
      end
    end
  end
end
