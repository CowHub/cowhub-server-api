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
    match = Match.find_by(id: params[:id])
    if match
      match.with_lock do
        match.results += 1
        match.save
      end

      # No match found
      if params[:value] == 'inf'
        render status: :ok
        return
      end
      match.with_lock do
        current_value = match.value
        image = ImprintImage.find_by(id: params[:image_id])
        if Float(params[:value]) < current_value && image
          match.imprint_image_id = image.id
          match.value = Float(params[:value])
        end
        if match.valid?
          match.save
          render status: :ok
        else
          render json: { error: match.errors.full_messages }, status: :bad_request
        end
      end
    else
      render status: :not_found
    end
  end
end
