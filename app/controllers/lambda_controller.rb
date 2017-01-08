class LambdaController < ApplicationController

  def match_count
    # Params: id, count
    match = Match.find_by(id: params[:id])
    if match && params[:count]
      match.count = params[:count]
      match.save
      render status: :ok
    else
      render status: :bad_request
    end
  end

  def match_result
    # Params: id, value, image_id
    match = match.Match.find_by(id: params[:id])
    if match && params[:image_id] && params[:value]
      match.results += 1
      current_value = match.value
      image = ImprintImage.find_by(id: image_id)
      if params[:value] < current_value && image
        match.image = image
        match.value = params[:value]
        match.save
      end
      render status: :ok
    else
      render status: :bad_request
    end
  end

end
