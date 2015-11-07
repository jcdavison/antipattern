class Api::EntitiesController < ApplicationController
  def index
    orgs = OCTOCLIENT.get("/users/#{current_user.github_username}/orgs", per_page: 100)
    org_objs = orgs.map {|org| {text: org[:login], id: org[:login], entityType: 'orgs'} }
    user_entity = { entityType: 'users', text: current_user.github_username, id: current_user.github_username }
    render json: { entities: org_objs.push(user_entity) }
    rescue
      render json: { entities: [] }
  end
end
