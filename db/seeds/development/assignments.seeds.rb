after 'development:lectures' do
  me = Coursewareable::User.find_by_email('stas@nerd.ro')
  my_classroom = me.classrooms.first

  my_classroom.lectures.limit(2).each do |lecture|
    Fabricate('coursewareable/assignment', :classroom => my_classroom,
              :user => me, :lecture => lecture)
  end

  my_classroom.lectures.offset(2).limit(2).each do |lecture|
    Fabricate('coursewareable/assignment', :classroom => my_classroom,
              :user => me, :lecture => lecture) do
      quiz [ {
        :options => [{
          :valid => true,
          :content => "Correct"
        }, {
          :valid => false,
          :content => "Wrong"
        }],
        :content => "Radio Question Title #{lecture.id}",
        :type => ["radios", "checkboxes"].sample
      } ]
    end
  end
end
