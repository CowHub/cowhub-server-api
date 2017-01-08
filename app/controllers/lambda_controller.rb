class LambdaController < ApplicationController
  def match_count
    # Params: id, count
    match = Match.find_by(id: params[:id])
    if match
      match.count = params[:count]
      if match.valid?
        match.save
        render status: :ok
      else
        render json: { error: match.errors.full_messages }, status: :bad_request
      end
    else
      render status: :not_found
    end
  end

  def match_result
    # Params: id, value, image_id
    match = match.Match.find_by(id: params[:id])
    if match
      match.results += 1
      match.save
      current_value = match.value
      image = ImprintImage.find_by(id: image_id)
      if params[:value] < current_value && image
        match.image = image
        match.value = params[:value]
      end
      if match.valid?
        match.save
        render status: :ok
      else
        render json: { error: match.errors.full_messages }, status: :bad_request
      end
    else
      render status: :not_found
    end
  end
end
