require 'spec_helper'

describe ClassroomsController do

  let(:classroom) { Fabricate(:classroom) }

  describe 'when one exists' do
    render_views

    it 'should be available from subdomain' do
      @request.host = "#{classroom.slug}.#{@request.host}"
      get :show
      response.should be_success
      response.body.should match(classroom.title)
    end
  end

end
