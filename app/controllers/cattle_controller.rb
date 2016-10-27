class CattleController < ApplicationController
  before_action :authenticate_request!

  def index
    render json: { cattle: current_user.cattle }, status: :ok
  end

  def new
    if Cattle.find_by(:country_code, :herdmark, :check_digit, :individual_number)
      render json: { errors: ['Cattle already registered'] }, status: :bad_request
    else
      cattle = Cattle.create(params.permit(Cattle.column_names))
      render json: { cattle: cattle }, status: :created
    end
  end

  def show
    cattle = current_user.cattle.find_by(params[:id])
    if cattle
      render json: { cattle: cattle }, status: :ok
    else
      render json: { errors: ['Cattle is not registered'] }, status: :not_found
    end
  end

  def search
    render json: { cattle: user.cattle.where(params.permit(Cattle.column_names)) }, status: :ok
  end

  def update
    cattle = Cattle.find_by(params[:id])
    if cattle
      info_columns = :name, :breed, :gender, :dob
      cattle.update_attributes(params.permit(info_columns))
      render json: { cattle: cattle.to_json }, status: :ok
    else
      render json: { errors: ['Cattle is not registered'] }, status: :not_found
    end
  end

  def destroy
    cattle = Cattle.find_by(params[:id])
    if cattle
      cattle.destroy
      render status: :ok
    else
      render json: { errors: ['Cattle is not registered'] }, status: :not_found
    end
  end
end
