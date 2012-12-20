module Coursewareable
  # Classroom controller
  class ClassroomsController < ApplicationController
    # Abilities checking
    load_and_authorize_resource :class => Coursewareable::Classroom

    before_filter :load_classroom, :only => [:dashboard, :edit, :update]

    # Classroom dashboard
    # Mapped to [Classroom] subdomain
    def dashboard
      @timeline = @classroom.all_activities
    end

    # Classroom creation page
    def new
      @new_classroom = current_user.created_classrooms.build
    end

    # Customization page
    def edit
      respond_to do |format|
        format.html
        format.json {
          result = {
            :query => params[:query],
            :suggestions => []
          }

          if params[:query].blank? or params[:query].to_s.size < 3
            render :json => result
          else
            suggestions = Coursewareable::User.search_by_name_and_email(
              params[:query], 'first_name, last_name, id, email', 5)

            suggestions.each do |user|
              result[:suggestions].push({
                :value => user.name,
                :user_id => user.id,
                :pic => GravatarImageTag::gravatar_url(user.email, :size => 30)
              }) unless user.id == current_user.id
            end

            render :json => result
          end

        } if params[:suggest_users]
      end
    end

    # Handles submitted changes
    def update
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
      @classroom.update_attributes(params[:classroom])

      new_members = params[:members].to_s.split(',').uniq.compact
      unless new_members.empty?
        @classroom.member_ids += new_members.map(&:to_i)
      end

      new_collabs = params[:collaborators].to_s.split(',').uniq.compact
      unless new_collabs.empty?
        @classroom.collaborator_ids += new_collabs.map(&:to_i)
      end

      redirect_to edit_classroom_url(:subdomain => @classroom.slug)
    end

    # Classroom creation hadler
    def create
      classroom = current_user.created_classrooms.build(params[:classroom])
      if classroom.save
        redirect_to(root_url(:subdomain => classroom.slug))
      else
        redirect_to(start_classroom_path)
      end
    end

    protected

    # Loads current classroom
    def load_classroom
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end

  end
end
