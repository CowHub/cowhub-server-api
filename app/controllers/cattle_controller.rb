class CattleController < ApplicationController
  before_action :authenticate_request!

  def index
    render json: { cattle: current_user.cattle }, status: :ok
  end

  def new
    if params[:imprint_image]
      cattle = current_user.cattle.create(params[:cattle].permit(Cattle.column_names))
      cattle.imprint_image.create(image: params[:imprint_image])
      cattle.profile_image.create(image: params[:profile_image]) if params[:profile_image]
      if cattle.valid?
        cattle.save
        render json: { cattle: cattle }, status: :created
      else
        render json: { errors: cattle.errors.full_messages }, status: :bad_request
      end
    else
      render json: { errors: ['No muzzle image provided'] }, status: :bad_request
    end
  end

  def show
    cattle = current_user.cattle.find_by(id: params[:id])
    if cattle
      render json: { cattle: cattle }, status: :ok
    else
      render status: :not_found
    end
  end

  def search
    render json: { cattle: current_user.cattle.where(params.permit(Cattle.column_names)) }, status: :ok
  end

  def update
    cattle = current_user.cattle.find_by(id: params[:id])
    if cattle
      cattle.assign_attributes(params.permit(Cattle.column_names))
      if cattle.valid?
        cattle.save
        render json: { cattle: cattle }, status: :ok
      else
        render json: { errors: cattle.errors.full_messages }, status: :bad_request
      end
    else
      render status: :not_found
    end
  end

  def destroy
    cattle = current_user.cattle.find_by(id: params[:id])
    if cattle
      cattle.destroy
      render status: :ok
    else
      render status: :not_found
    end
  end
end
