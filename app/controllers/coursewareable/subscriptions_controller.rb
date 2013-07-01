module Coursewareable
  # Courseware Subscriptions Controller
  class SubscriptionsController < ApplicationController

    # Do not check for abilities
    skip_load_and_authorize_resource

    def new
      @plans = Coursewareable.config.plans
    end

    def create
      plan = Coursewareable.config.plans[params[:plan].to_sym]
      user = Coursewareable::User.find(current_user.id)

      Stripe::Plan.create(
        :amount => plan[:cost] * 100,
        :interval => 'month',
        :name => '%s plan' % plan[:slug],
        :currency => 'usd',
        :id => plan[:slug]
      )

      Stripe::Customer.create(
        :email => user.email,
        :card => params[:stripeToken],
        :plan => plan[:slug]
      )

      user.plan.update_attributes(plan.except(:cost))

      flash[:success] = 'Thank you for subscribing to #{plan.slug} plan!'
      redirect_to me_users_path

    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_subscription_path
    end
  end
end
