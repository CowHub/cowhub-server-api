class CattleController < ApplicationController
  def index
    tag_params = Tag.parse_tag(params[:tag])
    tag = Tag.find_from_params(tag_params)
    unless tag
      puts tag
      render json: {
        error: 'Cattle is not registered'
      }, status: 404 # Not Found
      return
    end
    render json: {
      cattle: Cattle.find_by(tag_id: tag.id).to_json
    }, status: 200 # OK
  end

  def new
    if Tag.find_from_params(params)
      render json: {
        error: 'Tag already exists'
      }, status: 400 # Bad Request
      return
    end
    Tag.new_from_params(params)
    render status: 201 # Created
  end

  def update_cattle_info
    tag_params = Tag.parse_tag(params[:tag])
    tag = Tag.find_from_params(tag_params)
    tag = Tag.new_from_params(tag_params) if tag.nil?
    cattle = Cattle.find_by(tag_id: tag.id)
    cattle.update_attributes(params.permit(:name, :breed, :gender, :dob))
    render status: 200 # OK
  end

  def destroy
    tag_params = Tag.parse_tag(params[:tag])
    tag = Tag.find_from_params(tag_params)
    unless tag
      render json: {
        error: 'Cattle is not registered'
      }, status: 404 # Not Found
      return
    end
    Cattle.find_by(tag_id: tag.id).delete
    tag.delete
    render status: 200 # OK
  end
end
