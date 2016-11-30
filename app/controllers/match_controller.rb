class MatchController < ApplicationController
  before_action :authenticate_request!

  def new
    match = current_user.match.create(image_uri: params[:data])
    unless cattle.valid?
      render json: { errors: match.errors.full_messages }, status: :bad_request
      return
    end
    message = JSON.generate(
      mode: 'match',
      image: match.image_uri,
      server_id: Rails.application.config.server_id,
      request_id: match.id
    )
    Rails.application.config.task_queue.publish(message, persistent: true)
    render json: { id: match.id }, status: :ok
  end

  def show
    match = current_user.match.find_by(id: params[:id])
    unless match
      render status: :not_found
      return
    end
    case match.status
    when 'pending'
      render status: :ok
    when 'not_found'
      render status: :not_found
    when 'found'
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
