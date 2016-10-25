class CattleController < ApplicationController
  def index
    render json: { cattle: Cattle.all.limit(50) }, status: :ok
  end

  def new
    tag_columns = :country_code, :herdmark, :check_digit, :individual_number
    if Cattle.find_by(params.permit(tag_columns))
      render json: { errors: ['Cattle already registered'] }, status: :bad_request
      return
    end
    cattle = Cattle.create(params.permit(Cattle.column_names))
    render json: { cattle: cattle.to_json }, status: :created
  end

  def show
    cattle = Cattle.find(params[:id])
    render json: { cattle: cattle.to_json }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Cattle is not registered'] }, status: :not_found
  end

  def search
  end

  def update
    cattle = Cattle.find(params[:id])
    cattle.update_attributes(params.permit(Cattle.column_names))
    render json: { cattle: cattle.to_json }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Cattle is not registered'] }, status: :not_found
  end

  def destroy
    cattle = Cattle.find(params[:id])
    cattle.destroy
    render status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Cattle is not registered'] }, status: :not_found
  end

  def upload_imprint
  end

  def match
  end
end
