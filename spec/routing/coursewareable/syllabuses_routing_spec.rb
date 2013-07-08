require 'spec_helper'

describe Coursewareable::SyllabusesController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for syllabus' do
      get('http://test.lvh.me/syllabus').should route_to(
        'coursewareable/syllabuses#show')
    end

    it 'for creation screen' do
      get('http://test.lvh.me/syllabus/edit').should route_to(
        'coursewareable/syllabuses#edit')
    end

    it 'for creation' do
      post('http://test.lvh.me/syllabus').should route_to(
        'coursewareable/syllabuses#create')
    end

    it 'for updating' do
      put('http://test.lvh.me/syllabus').should route_to(
        'coursewareable/syllabuses#update')
    end
  end
end
