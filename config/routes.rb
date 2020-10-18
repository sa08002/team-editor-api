Rails.application.routes.draw do
  root 'v1/articles#index'
  namespace :v1 do
    mount_devise_token_auth_for "User", at: "auth", controllers: {
      registrations: "v1/auth/registrations",
    }

    namespace :articles do
      resources :searches, only: [:index]
    end

    resources :articles do
      resources :comments, controller: "articles/comments"
      resources :article_likes, controller: "articles/article_likes"
    end
    resources :comments do
      resources :comment_likes, controller: "comments/comment_likes"
    end
  end
end
