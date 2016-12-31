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
    if params[:data].nil? || params[:data].empty?
      render status: :bad_request
    elsif cattle
      image_uri = "cattle/#{current_user.id}/#{cattle.id}/image-original"
      $s3.put_object(
        acl: 'private',
        body: params[:data],
        bucket: 'cowhub-production-images',
        key: image_uri
      )
      image = cattle.image.create(image_uri: image_uri)
      if image.valid?
        image.save
        render json: { image: image }, status: :ok
      else
        render json: { errors: image.errors.full_messages }, status: :bad_request
      end
    else
      render status: :not_found
    end
  end
end
