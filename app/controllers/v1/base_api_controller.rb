class V1::BaseApiController < ApplicationController
  protect_from_forgery with: :null_session
  alias_method :current_user, :current_v1_user
  serialization_scope :view_context

end
