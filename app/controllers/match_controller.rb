class MatchController < ApplicationController
  before_action :authenticate_request!

  def new
    if params[:data].nil? || params[:data].empty?
      render status: :bad_request
      return
    end
    match = current_user.match.create
    image_uri = "match/#{current_user.id}/#{match.id}/image-original"
    $s3.put_object(
      acl: 'private',
      body: params[:data],
      bucket: 'cowhub-production-images',
      key: image_uri
    )
    match.image_uri = image_uri
    unless match.valid?
      render json: { errors: match.errors.full_messages }, status: :bad_request
      return
    end
    match.save
    render json: { match: match }, status: :ok
  end

  def show
    match = current_user.match.find_by(id: params[:id])
    unless match
      render status: :not_found
      return
    else
      case match.status
      when :pending
        render status: :ok
      when :not_found
        render status: :not_found
      when :found
        cattle = Cattle.find_by(id: match.cattle_id)
        if cattle
          render json: { cattle: cattle }, status: :ok
        else
          # Match found against lost cattle
          render status: :not_found
        end
      else
        render status: :bad_request
      end
    end
  end
end
