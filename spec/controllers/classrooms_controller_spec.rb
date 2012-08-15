require 'spec_helper'

describe ClassroomsController do

  let(:classroom) { Fabricate(:classroom) }

  describe 'when one exists' do
    render_views

    it 'should serve from subdomain' do
      login_user_post(classroom.owner.email, 'secret')
      visit root_url(nil, :subdomain => classroom.slug)
      page.status_code.should eq(200)
      page.should have_content(classroom.title)
    end
  end

end
