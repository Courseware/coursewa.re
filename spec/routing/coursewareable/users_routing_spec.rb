require 'spec_helper'

describe Coursewareable::UsersController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for signup screen' do
      get('/users/new').should route_to('coursewareable/users#new')
      get('/signup').should route_to('coursewareable/users#new')
    end

    it 'for signup' do
      post('/users').should route_to('coursewareable/users#create')
      post('/signup').should route_to('coursewareable/users#create')
    end

    it 'for activation' do
      get('/users/token/activate').should route_to(
        'coursewareable/users#activate', :id => 'token'
      )
    end

    it 'for personal profile page' do
      get('/users/me').should route_to('coursewareable/users#me')
    end

    it 'for account page' do
      get('/users/my_account').should route_to(
        'coursewareable/users#my_account')
    end

    it 'for invitation page' do
      get('/users/invite').should route_to('coursewareable/users#invite')
    end

    it 'for processing invitation' do
      post('/users/send_invitation').should route_to(
        'coursewareable/users#send_invitation')
    end

    it 'for personal profile page updates' do
      put('/users/1').should route_to('coursewareable/users#update', :id => '1')
    end

    it 'for notifications settings page' do
      get('/users/notifications').should route_to(
        'coursewareable/users#notifications')
    end

    it 'for notifications settings update' do
      put('/users/notifications').should route_to(
        'coursewareable/users#update_notifications')
    end

    it 'for delete page' do
      get('/users/request_deletion').should route_to(
        'coursewareable/users#request_deletion')
    end

    it 'for delete request' do
      post('/users/request_deletion').should route_to(
        'coursewareable/users#request_deletion')
    end
  end
end
