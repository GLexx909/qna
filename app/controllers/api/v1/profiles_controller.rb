class Api::V1::ProfilesController < Api::V1::BaseController

  def index
    @users = User.where.not(id: current_resource_owner.id)
    authorize! :read, @users

    render json: @users, each_serializer: User::ProfileSerializer
  end

  def me
    render json: current_resource_owner
    authorize! :read, @users
  end
end
