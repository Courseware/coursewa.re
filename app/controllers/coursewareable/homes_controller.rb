module Coursewareable
  # Courseware Main Page Controller class
  class HomesController < ApplicationController

    # Do not check for abilities, but load the class properly
    load_and_authorize_resource :class => Coursewareable::Classroom
    skip_authorize_resource
    # Do not require login for homepage
    skip_before_filter :require_login, :except => [:dashboard]

    # Main page handler
    def index
      if logged_in?
        redirect_to(dashboard_home_path)
      else
        render(:layout => 'landing')
      end
    end

    # User Dashboard handler
    def dashboard
      redirect_to root_path unless logged_in?
      timeline = current_user.activities_as_owner.reverse
      @timeline = Kaminari.paginate_array(timeline).page(params[:page])
      render(:partial => 'shared/timeline') if request.xhr?
    end

    # About page
    def about
    end

    # Contact/Feedback page
    def contact
      @categories = [
        [_('General support question'), :general],
        [_('Everything but support'), :other],
      ]
    end

    # Feedback form processing
    def feedback
      sum = params[:val1].to_i + params[:val2].to_i
      [:email, :name, :message, :sum].each do |key|
        if params[key].blank? or (key == :sum and sum != params[:sum].to_i)
          flash[:alert] = _('Please fill in all the fields first.')
          redirect_to(contact_home_path) and return
        end
      end

      params[:remote_ip] = request.remote_ip

      if params[:category] == 'general'
        ::GenericMailer.delay.support_email(params)
      else
        ::GenericMailer.delay.contact_email(params)
      end

      flash[:success] = _('Thank you. Your message is on its way to us.')
      redirect_to(contact_home_path)
    end

  end
end
