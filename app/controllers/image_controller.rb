class ImageController < ApplicationController
  before_action :authenticate_request!

  def index
    cattle = current_user.cattle.find_by(id: params[:id])
    if cattle
      images = []
      cattle.image.each do |i|
        images.append(
          id: i.id,
          data: $s3.get_object(
            bucket: 'cowhub-production-images',
            key: i.image_uri
          ).body.read
        )
      end
      render json: {
        images: images
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
      image = cattle.image.create(image_uri: 'temporary')
      image_uri = "cattle/#{current_user.id}/#{cattle.id}/#{image.id}-image-original"
      $s3.put_object(
        acl: 'private',
        body: params[:data],
        bucket: 'cowhub-production-images',
        key: image_uri
      )
      image.image_uri = image_uri
      if image.valid?
        image.save
        render json: { id: image.id }, status: :ok
      else
        render json: { errors: image.errors.full_messages }, status: :bad_request
      end
    else
      render status: :not_found
    end
  end
end
