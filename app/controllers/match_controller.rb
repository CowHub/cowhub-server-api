class MatchController < ApplicationController
  before_action :authenticate_request!

  def new
    unless params[:data]
      render json: { errors: ['no image uploaded'] }, status: :bad_request
      return
    end
    match = current_user.match.create(image_uri: params[:data])
    message = JSON.generate(
      mode: 'match',
      image: params[:data],
      server_id: Rails.application.config.server_id,
      request_id: match.id
    )
    Rails.application.config.task_queue.publish(message, persistent: true)
    render json: { matchId: match.id }, status: :ok
  end

  def show
    match = Match.find_by(id: params[:id])
    unless match
      render json: { errors: ['match request  not found'] }, status: :not_found
      return
    end
    case match.status
    when 'pending'
      render status: :ok
    when 'not_found'
      render json: { errors: ['no matches were found'] }, status: :not_found
    else
      cattle = Cattle.find_by(id: match.cattle_id)
      if cattle
        render json: { cattle: cattle }, status: :ok
      else
        render json: { errors: ['match found but cattle lost'] }, status: :not_found
      end
    end
  end
end
