require 'date'

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
    match.stored = true
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
    if match
      response = { pending: false, found: nil, cattle: nil }
      match.with_lock do
        if (match.count != -1 && match.results >= match.count) ||
           DateTime.now - match.updated_on > 10
          response[:found] = match.value != -1
          response[:cattle] = match.cattle if response[:found]
          if match.stored
            $s3.delete_object(
              bucket: 'cowhub-production-images',
              key: match.image_uri
            )
            match.stored = false
            match.save!
          end
        else
          response[:pending] = true
        end
      end
      render json: response, status: :ok
    else
      render status: :not_found
    end
  end
end
