include OctoHelper
include QueryHelper
include ObjHelper
include StructuralHelper

class CommentsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end
end
