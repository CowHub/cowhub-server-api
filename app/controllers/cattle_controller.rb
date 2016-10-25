class CattleController < ApplicationController
  before_action :authenticate_request!

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
    cattle = []
    Cattle.where(params.permit(Cattle.column_names)).each do |c|
      cattle.push(c.to_json)
    end
    render json: { cattle: cattle }, status: :ok
  end

  def update
    cattle = Cattle.find(params[:id])
    info_columns = :name, :breed, :gender, :dob
    cattle.update_attributes(params.permit(info_columns))
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
    begin
      Cattle.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ['Cattle is not registered'] }, status: :not_found
      return
    end

    if BiometricImprint.find_by(cattle_id: params[:id])
      render json: { errors: ['Cattle imprint already uploaded'] }, status: :bad_request
      return
    end
    BiometricImprint.create(cattle_id: params[:id], imprint: params[:imprint])
    render status: :ok
  end

  def match
    imprint = BiometricImprint.find_by(imprint: params[:imprint])
    unless imprint
      render json: { errors: ['Could not match imprint'] }, status: :not_found
      return
    end
    render json: { cattle: imprint.cattle.to_json }, status: :ok
  end
end
