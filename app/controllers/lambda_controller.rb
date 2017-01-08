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
      if params[:value] < current_value
        match.image_id = params[:image_id]
        match.value = params[:value]
        match.save
      end
      render status: :ok
    else
      render status: :bad_request
    end
  end

end
