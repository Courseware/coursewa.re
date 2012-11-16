require 'spec_helper'

describe SyllabusesController do
  describe 'routing' do

    it 'for syllabus' do
      get('http://test.lvh.me/syllabus').should route_to('syllabuses#show')
    end

    it 'for creation screen' do
      get('http://test.lvh.me/syllabus/edit').should route_to('syllabuses#edit')
    end

    it 'for creation' do
      post('http://test.lvh.me/syllabus').should route_to('syllabuses#create')
    end

    it 'for updating' do
      put('http://test.lvh.me/syllabus').should route_to('syllabuses#update')
    end

  end
end
