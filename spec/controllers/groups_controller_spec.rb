require 'spec_helper'

describe GroupsController do

  let(:group) { Fabricate(:group) }

  describe 'when one exists' do
    render_views

    it 'should be available from subdomain' do
      @request.host = "#{group.slug}.#{@request.host}"
      get('show')
      response.should be_success
      response.body.should match(group.title)
    end
  end

end
