class Api::V1::ProfileController < Api::V1::BaseController
  def index
    @users = User.where(admin: nil)
    render json: @users
  end

  def me
    render json: current_resource_owner
  end
end
