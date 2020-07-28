require "rails_helper"

RSpec.describe "V1::Auth::Registrations", type: :request do
  describe "POST /v1/auth" do
    subject { post(v1_user_registration_path, params: params) }

    context "新規登録時" do
      let(:params) { attributes_for(:user) }
      it "トークン情報を取得でき、正常に登録できる。" do
        subject
        expect(headers["access-token"]).to be_present
        expect(headers["client"]).to be_present
        expect(headers["uid"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "新規登録時、email に入力がない場合" do
      let(:params) { attributes_for(:user, email: nil) }
      it "登録できない。" do
        subject
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "新規登録時、password に入力がない場合" do
      let(:params) { attributes_for(:user, password: nil) }
      it "登録できない。" do
        subject
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /v1/auth/sign_in" do
    subject { post(v1_user_session_path, params: params) }

    context "ログイン時" do
      let(:user) { create(:user) }
      let(:params) { { name: user.name, email: user.email, password: user.password } }
      it "トークン情報を取得でき、正常にログインできる。" do
        subject
        expect(headers["access-token"]).to be_present
        expect(headers["client"]).to be_present
        expect(headers["uid"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン時、email の入力が違う場合" do
      let(:user) { create(:user) }
      let(:params) { { name: user.name, email: Faker::Internet.email, password: user.password } }
      it "ログインできない。" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "ログイン時、password の入力が違う場合" do
      let(:user) { create(:user) }
      let(:params) { { name: user.name, email: user.email, password: Faker::Internet.password } }
      it "ログインできない。" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /v1/auth/sign_out" do
    subject { delete(destroy_v1_user_session_path, headers: headers) }

    context "ログアウト時" do
      let(:user) { create(:user) }
      let(:headers) { user.create_new_auth_token }
      it "トークン情報がなくなり、正常にログアウトできる。" do
        subject
        expect(user.reload.tokens).to be_blank
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
