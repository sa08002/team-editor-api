Rails.application.routes.draw do
  namespace :v1 do
    mount_devise_token_auth_for "User", at: "auth", controllers: {
      registrations: "v1/auth/registrations",
    }
    resources :articles do
      resources :comments, controller: "articles/comments"

    end
  end
end
