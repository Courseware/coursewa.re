# Courseware group controller
class GroupsController < ApplicationController

  skip_before_filter :require_login, :only => [:show]

  def show
    @group = Group.find_by_slug!(request.subdomain)
  end
end
