include OctoHelper

class Api::EntitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    client = build_octoclient current_user.octo_token
    orgs = client.get("/user/orgs", per_page: 100)
    org_objs = orgs.map {|org| {text: org[:login], id: org[:login], entityType: 'orgs'} }
    user_entity = { entityType: 'user', text: current_user.github_username, id: current_user.github_username }
    render json: { entities: org_objs.push(user_entity) }
    rescue
      render json: { entities: [] }, status: 401
  end
end
