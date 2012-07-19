desc 'Show some QA details about the code'
task qa: [:stats, 'doc:stats'] do
  sh 'rails_best_practices -x schema --spec'
end
