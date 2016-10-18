class CattleController < ApplicationController
  def index
    render json: { cattle: Cattle.all.limit(50) }, status: :ok
  end

  def show
    tag_params = Tag.parse_tag(params[:tag])
    tag = Tag.find_by(tag_params)
    unless tag
      render json: { errors: ['Cattle is not registered'] }, status: :not_found
      return
    end
    cattle = Cattle.find_by(tag_id: tag.id)
    render json: { cattle: cattle.to_json }, status: :ok
  end

  def new
    if Tag.find_by(params.permit(Tag.column_names))
      render json: { errors: ['Tag already registered'] }, status: :bad_request
      return
    end
    tag = Tag.create(params.permit(Tag.column_names))
    render json: { tag: tag }, status: :created
  end

  def update
    tag_params = Tag.parse_tag(params[:tag])
    tag = Tag.find_by(tag_params)
    tag = Tag.create(tag_params) if tag.nil?
    cattle = Cattle.find_by(tag_id: tag.id)
    cattle.update_attributes(params.permit(Cattle.column_names))
    render status: 200 # OK
  end

  def destroy
    tag_params = Tag.parse_tag(params[:tag])
    tag = Tag.find_by(tag_params)
    unless tag
      render json: { errors: ['Cattle is not registered'] }, status: :not_found
      return
    end
    tag.destroy
    render status: :ok
  end
end
