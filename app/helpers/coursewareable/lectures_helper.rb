module Coursewareable
  # Courseware lectures controller helpers
  module LecturesHelper
    # Outputs a hierarchical structure of lectures based on its parent/children
    def list_lecture_options(lectures, listed_ids = [], indent = '')
      output = ''
      lectures.each do |lecture|
        unless listed_ids.include?(lecture.id)
          listed_ids.push(lecture.id)
          output += render(:partial => 'lecture_options', :locals => {
            :lecture => lecture, :listed_ids => listed_ids, :indent => indent})
        end
      end
      return output.html_safe
    end
  end
end

