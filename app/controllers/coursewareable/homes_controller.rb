module Coursewareable
  # Courseware Main Page Controller class
  class HomesController < ApplicationController

    # Do not check for abilities, but load the class properly
    load_and_authorize_resource :class => Coursewareable::Classroom
    skip_authorize_resource
    # Do not require login for homepage
    skip_before_filter :require_login, :except => [:dashboard, :survey]

    # Main page handler
    def index
      if logged_in?
        redirect_to(dashboard_home_path)
      else
        render('coursewareable/sessions/new')
      end
    end

    # User Dashboard handler
    def dashboard
      redirect_to root_path unless logged_in?
      timeline = current_user.activities_as_owner.reverse
      @timeline = Kaminari.paginate_array(timeline).page(params[:page])
      render(:partial => 'shared/timeline') if request.xhr?
    end

    # Feedback form processing
    def feedback
      sum = params[:val1].to_i + params[:val2].to_i
      [:email, :name, :message, :sum].each do |key|
        if params[key].blank? or (key == :sum and sum != params[:sum].to_i)
          flash[:alert] = _('Please fill in all the fields first.')
          redirect_to(root_path) and return
        end
      end

      params[:remote_ip] = request.remote_ip

      if params[:category] == 'general'
        ::GenericMailer.delay.support_email(params)
      else
        ::GenericMailer.delay.contact_email(params)
      end

      flash[:success] = _('Thank you. Your message is on its way to us.')
      redirect_to(root_path)
    end

    # User feedback survey handler
    def survey
      if params[:message].blank?
        message = _('You did not write anything. Please try again.')
      else
        params[:name] = current_user.name
        params[:email] = current_user.email
        params[:remote_ip] = request.remote_ip
        message = _('Thank you for sharing your experience with us.')
        ::GenericMailer.delay.survey_email(params)
      end

      if request.xhr?
        render(:layout => false, :inline => message)
      else
        redirect_to(dashboard_home_path, :notice => message)
      end
    end

  end
end
