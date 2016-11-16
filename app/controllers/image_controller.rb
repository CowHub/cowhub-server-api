class ImageController < ApplicationController
  before_action :authenticate_request!

  def index
    cattle = current_user.cattle.find_by(id: params[:id])
    if cattle
      render json: {
        images: cattle.image
      }, status: :ok
    else
      render json: {}, status: :not_found
    end
  end

  def upload
    cattle = current_user.cattle.find_by(id: params[:id])
    if cattle
      image = cattle.image.create(image_uri: params[:data])
      if image.valid?
        image.save
        render json: { image: image }, status: :ok
      else
        render json: { errors: image.errors.full_messages }, status: :bad_request
      end
    else
      render json: {}, status: :not_found
    end
  end

  def request_verification
    unless params[:data]
      render json: { errors: ['no image uploaded'] }, status: :bad_request
      return
    end
    image = VerificationImage.create(image_uri: params[:data])
    message = JSON.generate(id: image.id)
    Rails.application.config.task_queue.publish(message, persistent: true)
    render json: { verificationID: image.id }, status: :ok
  end

  def check_verification
    verification = VerificationImage.find_by(id: params[:id])
    unless verification
      render json: { errors: ['verification request  not found'] }, status: :not_found
      return
    end
    case verification.cattle_id
    when nil
      render status: :ok
    when -1
      render json: { errors: ['no matches were found'] }, status: :not_found
    else
      cattle = Cattle.find_by(id: verification.cattle_id)
      if cattle
        render json: { cattle: cattle }, status: :ok
      else
        render json: { errors: ['match found but cattle lost'] }, status: :not_found
      end
    end
  end
end
