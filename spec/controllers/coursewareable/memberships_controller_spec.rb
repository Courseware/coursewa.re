require 'spec_helper'

describe Coursewareable::MembershipsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:new_member) { Fabricate(:confirmed_user) }

  describe 'DELETE :destroy' do

    before { classroom.members << new_member }

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        delete :destroy, :id => new_member.id, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        delete :destroy, :id => new_member, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should destroy the member' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        delete :destroy, :use_route => :coursewareable, :id => new_member.id
        response.should redirect_to(edit_classroom_path)
      end

      it 'should do nothing if member is missing' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"

        delete :destroy, :use_route => :coursewareable, :id => new_member.id * 9

        response.should redirect_to('/404')
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        delete :destroy, :use_route => :coursewareable, :id => new_member.id
        response.should redirect_to('/404')
      end
    end

  end

end
