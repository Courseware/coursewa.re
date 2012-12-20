module Coursewareable
  # Classroom controller
  class ClassroomsController < ApplicationController
    # Abilities checking
    load_and_authorize_resource :class => Coursewareable::Classroom

    # Classroom dashboard
    # Mapped to [Classroom] subdomain
    def dashboard
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
      @timeline = @classroom.all_activities
    end

    # Classroom creation page
    def new
      @new_classroom = current_user.created_classrooms.build
    end

    # Customization page
    def edit
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
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
      classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
      classroom.update_attributes(params[:classroom])

      if(new_members = params[:members].to_s.split(',').uniq.compact and
        not new_members.empty?)
        new_members.each do |mem_id|
          classroom.member_ids += [mem_id.to_i]
        end
      end

      if(new_collabs = params[:collaborators].to_s.split(',').uniq.compact and
        not new_collabs.empty?)
        new_collabs.each do |collab_id|
          classroom.collaborator_ids += [collab_id.to_i]
        end
      end

      if classroom.save
        flash[:success] = _('Classroom updated')
      else
        flash[:alert] = _('Classroom was not updated. Please try again.')
      end

      # TODO: Fix redirect flashes
      redirect_to edit_classroom_url(:subdomain => classroom.slug)
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
  end
end
