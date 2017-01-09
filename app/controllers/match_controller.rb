class MatchController < ApplicationController
  before_action :authenticate_request!

  def new
    if params[:data].nil? || params[:data].empty?
      render status: :bad_request
      return
    end
    match = current_user.match.create!(image_uri: 'temporary')
    image_uri = "match/#{current_user.id}/#{match.id}-image-original"
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
    puts "------- MATCH \n\n#{match.to_json}\n\n--------"
    if match && match.results >= match.count
      match.status = 'not_found' if match.value == -1 else 'found'
    end
    if match
      response = { pending: nil, found: nil, lost: nil, cattle: nil }
      case match.status
      when 'pending'
        response[:pending] = true
        render json: response, status: :ok
      when 'not_found'
        response[:pending] = false
        response[:found] = false
        render json: response, status: :ok
      when 'found'
        image = ImprintImage.find_by(id: params[:image_id])
        response[:pending] = false
        response[:found] = true
        response[:lost] = image && image.cattle
        render json: response, status: :ok
      else
        render status: :bad_request
      end
    else
      render status: :not_found
    end
  end
end
