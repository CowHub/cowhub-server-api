class ImageController < ApplicationController
  before_action :authenticate_request!

  def index
    cattle = current_user.cattle.find_by(id: params[:id])
    if cattle
      render json: { images: cattle.profile_images }, status: :ok
    else
      render json: {}, status: :not_found
    end
  end

  def show
    image = ProfileImage.find_by(id: params[:id])
    if image
      if image.cattle.user_id == current_user.id
        render json: { image: image.fetch_image }, status: :ok
      else
        render json: { errors: ['Cattle does not belongs to you'] }, status: :unauthorized
      end
    else
      render json: {}, status: :not_found
    end
  end

  def upload
    cattle = current_user.cattle.find_by(id: params[:id])
    if params[:data].nil? || params[:data].empty?
      render status: :bad_request
    elsif cattle
      image = cattle.profile_image.create(image: params[:data])
      if image.valid?
        render json: { id: image.id }, status: :ok
      else
        render json: { errors: image.errors.full_messages }, status: :bad_request
      end
    else
      render status: :not_found
    end
  end
end
