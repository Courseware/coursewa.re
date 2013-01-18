module Coursewareable
  # Courseware syllabuses controller helpers
  module SyllabusesHelper
    # Outputs a hierarchical structure of lectures based on its parent/children
    def list_lectures_tree(lectures, listed_ids = [])
      output = ''
      lectures.each do |lecture|
        unless listed_ids.include?(lecture.id)
          listed_ids.push(lecture.id)
          output += render(:partial => 'lectures_listing', :locals => {
            :lecture => lecture, :listed_ids => listed_ids})
        end
      end
      return output.html_safe
    end
  end
end
