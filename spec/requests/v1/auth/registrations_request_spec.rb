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
        expect(response).to have_http_status(200)
      end
    end
    
    context "新規登録時、email に入力がない場合" do
      let(:params) { attributes_for(:user, email: nil) }
      it "登録できない。" do
        subject
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(422)
      end
    end

    context "新規登録時、password に入力がない場合" do
      let(:params) { attributes_for(:user, password: nil) }
      it "登録できない。" do
        subject
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(422)
      end
    end
  end
end
